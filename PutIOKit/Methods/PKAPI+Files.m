//
//  PKAPI+Files.m
//  PutIOKit
//
//  Copyright © 2018 Mark Bourke.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE
//

#import "PKAPI+Files.h"
#import "PKError.h"
#import "PKEndpoints.h"
#import "PKFile.h"
#import "PKObjectProtocol.h"
#import "PKTransfer.h"
#import "PKAuth.h"
#import "AFOAuthCredential.h"
#import "PKMP4Conversion.h"
#import "PKShare.h"
#import "PKShareRecipient.h"
#import "PKSubtitle.h"
#import "PKEvent.h"

@implementation PKAPI (Files)

+ (NSURLSessionDataTask *)listFilesInFolderWithID:(NSInteger)folderIdentifier
                                         callback:(void (^)(NSError * _Nullable, NSArray<PKFile *> * _Nonnull, PKFile * _Nullable))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPKEndpointListFiles];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"parent_id" value:@(folderIdentifier).stringValue],
                              [NSURLQueryItem queryItemWithName:@"oauth_token" value:[PKAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error) {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSMutableArray *files = [NSMutableArray array];
        
        for (NSDictionary *filesDictionary in [responseDictionary objectForKey:@"files"]) {
            id file = [PKFile alloc];
            
            if ([file conformsToProtocol:@protocol(PKObjectProtocol)]) {
                file = [file initFromDictionary:filesDictionary];
                
                file == nil ?: [files addObject:file];
            }
        }
        
        id parent = [PKFile alloc];
        
        if ([parent conformsToProtocol:@protocol(PKObjectProtocol)]) {
            parent = [parent initFromDictionary:[responseDictionary objectForKey:@"parent"]];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, files, parent);
        }];
    }];
}

+ (NSURLSessionDataTask *)searchFilesWithQuery:(NSString *)query
                                        onPage:(NSInteger)page
                                      callback:(void (^)(NSError * _Nullable, NSArray<PKFile *> * _Nonnull, NSURL * _Nullable))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[kPKEndpointSearchFiles stringByAppendingFormat:@"/%@/page/%@", query, @(page).stringValue]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token" value:[PKAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error) {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSMutableArray *files = [NSMutableArray array];
        
        for (NSDictionary *filesDictionary in [responseDictionary objectForKey:@"files"]) {
            id file = [PKFile alloc];
            
            if ([file conformsToProtocol:@protocol(PKObjectProtocol)]) {
                file = [file initFromDictionary:filesDictionary];
                
                file == nil ?: [files addObject:file];
            }
        }
        
        NSURL *nextPageURL = [NSURL URLWithString:[[responseDictionary objectForKey:@"next"] stringValue]];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, files, nextPageURL);
        }];
    }];
}

+ (NSURLSessionUploadTask *)uploadFileAtURL:(NSURL *)fileURL
                             toFolderWithID:(NSInteger)parentIdentifier
                                newFileName:(NSString * _Nullable)fileName
                                   callback:(void (^)(NSError * _Nullable, PKFile * _Nullable))callback {
    NSAssert(![[fileURL pathExtension] isEqualToString:@".torrent"], @"Please use `uploadTorrentFileAtPath: fileName:parentIdentifier:callback:` instead.");
    
    if (fileName == nil) fileName = [fileURL lastPathComponent];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kPKEndpointUploadFiles]];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    return [session uploadTaskWithRequest:request fromFile:fileURL
                        completionHandler:^(NSData * _Nullable data,
                                            NSURLResponse * _Nullable response,
                                            NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        id file = [PKFile alloc];
        
        if ([file conformsToProtocol:@protocol(PKObjectProtocol)]) {
            file = [file initFromDictionary:[responseDictionary objectForKey:@"file"]];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, file);
        }];
    }];
}

+ (NSURLSessionUploadTask *)uploadTorrentFileAtURL:(NSURL *)torrentURL
                                    toFolderWithID:(NSInteger)parentIdentifier
                                       newFileName:(NSString * _Nullable)fileName
                                          callback:(void (^)(NSError * _Nullable, PKTransfer * _Nullable))callback {
    NSAssert([[torrentURL pathExtension] isEqualToString:@".torrent"], @"Please use `uploadFileAtPath: fileName:parentIdentifier:callback:` instead.");
    
    if (fileName == nil) fileName = [torrentURL lastPathComponent];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kPKEndpointUploadFiles]];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    return [session uploadTaskWithRequest:request fromFile:torrentURL
                        completionHandler:^(NSData * _Nullable data,
                                            NSURLResponse * _Nullable response,
                                            NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        id transfer = [PKTransfer alloc];
        
        if ([transfer conformsToProtocol:@protocol(PKObjectProtocol)]) {
            transfer = [transfer initFromDictionary:[responseDictionary objectForKey:@"transfer"]];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, transfer);
        }];
    }];
}

+ (NSURLSessionDataTask *)createFolderNamed:(NSString *)folderName
                          inDirectoryWithID:(NSInteger)parentIdentifier
                                   callback:(PKErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPKEndpointCreateFolder];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"name" value:folderName],
                              [NSURLQueryItem queryItemWithName:@"parent_id" value:@(parentIdentifier).stringValue],
                              [NSURLQueryItem queryItemWithName:@"oauth_token" value:[PKAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    
    return [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error);
        }];
    }];
}

+ (NSURLSessionDataTask *)getFileForID:(NSInteger)fileIdentifier callback:(void (^)(NSError * _Nullable, PKFile * _Nullable))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd", kPKEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token" value:[PKAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error) {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        id file = [PKFile alloc];
        
        if ([file conformsToProtocol:@protocol(PKObjectProtocol)]) {
            file = [file initFromDictionary:[responseDictionary objectForKey:@"file"]];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, file);
        }];
    }];
}

+ (NSURLSessionDataTask *)deleteFilesWithIDs:(NSArray<NSNumber *> *)fileIdentifiers
                                    callback:(PKErrorOnlyCallback)callback {
    NSParameterAssert(fileIdentifiers.count > 0);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPKEndpointDeleteFiles];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"file_ids"
                                                          value:[fileIdentifiers componentsJoinedByString:@","]],
                              [NSURLQueryItem queryItemWithName:@"oauth_token" value:[PKAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    
    return [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error);
        }];
    }];
}

+ (NSURLSessionDataTask *)renameFileWithID:(NSInteger)fileIdentifier
                                    toName:(NSString *)newName
                                  callback:(PKErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPKEndpointRenameFile];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"file_id" value:@(fileIdentifier).stringValue],
                              [NSURLQueryItem queryItemWithName:@"oauth_token" value:[PKAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    
    return [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error);
        }];
    }];
}

+ (NSURLSessionDataTask *)moveFilesWithIDs:(NSArray<NSNumber *> *)fileIdentifiers
                            toFolderWithID:(NSInteger)destinationIdentifier
                                  callback:(PKErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPKEndpointMoveFile];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"file_ids"
                                                          value:[fileIdentifiers componentsJoinedByString:@","]],
                              [NSURLQueryItem queryItemWithName:@"parent_id" value:@(destinationIdentifier).stringValue],
                              [NSURLQueryItem queryItemWithName:@"oauth_token" value:[PKAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    
    return [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error);
        }];
    }];
}

+ (NSURLSessionDataTask *)beginConvertingFileWithIDToMP4:(NSInteger)fileIdentifier
                                                callback:(PKErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/mp4", kPKEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    
    return [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error);
        }];
    }];
}

+ (NSURLSessionDataTask *)getMP4ConversionStatusForFileWithID:(NSInteger)fileIdentifier
                                                     callback:(void (^)(NSError * _Nullable, PKMP4Conversion *  _Nullable))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/mp4", kPKEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        id status = [PKMP4Conversion alloc];
        
        if ([status conformsToProtocol:@protocol(PKObjectProtocol)]) {
            status = [status initFromDictionary:[responseDictionary objectForKey:@"mp4"]];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, status);
        }];
    }];
}

+ (NSURLSessionDownloadTask *)downloadFileForID:(NSInteger)fileIdentifier callback:(void (^)(NSError * _Nullable, NSURL * _Nullable))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/download", kPKEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    return [session downloadTaskWithURL:components.URL completionHandler:^(NSURL * _Nullable location,
                                                                        NSURLResponse * _Nullable response,
                                                                        NSError * _Nullable error) {
        NSURL *fileURL;
        
        if (error == nil) {
            NSFileManager *manager = [NSFileManager defaultManager];
            NSURL *downloadsDirectoryURL = [[manager URLsForDirectory:NSDownloadsDirectory inDomains:NSUserDomainMask] firstObject];
            fileURL = [downloadsDirectoryURL URLByAppendingPathComponent:response.suggestedFilename];
            
            [manager moveItemAtURL:downloadsDirectoryURL toURL:fileURL error:&error];
            
            if (error != nil) fileURL = nil; // Set fileURL to `nil` if there was an error moving the fileURL so as to not confuse the developer with both a nonull "error" and "url" parameter.
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, fileURL);
        }];
    }];
}

+ (NSURLSessionDataTask *)shareFilesWithIDs:(NSArray<NSNumber *> *)fileIdentifiers
                           withFriendsNamed:(NSArray<NSString *> *)friends
                                   callback:(PKErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPKEndpointShareFiles];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"file_ids"
                                                          value:[fileIdentifiers componentsJoinedByString:@","]],
                              [NSURLQueryItem queryItemWithName:@"friends"
                                                          value:[friends componentsJoinedByString:@","]],
                              [NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    
    return [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error);
        }];
    }];
}

+ (NSURLSessionDataTask *)listSharesWithCallback:(void (^)(NSError * _Nullable, NSArray<PKShare *> * _Nonnull))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPKEndpointSharedFiles];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSMutableArray *shares = [NSMutableArray array];
        
        for (NSDictionary *sharesDictionary in [responseDictionary objectForKey:@"shared"]) {
            id share = [PKShare alloc];
            
            if ([share conformsToProtocol:@protocol(PKObjectProtocol)]) {
                share = [share initFromDictionary:sharesDictionary];
            }
            
            share == nil ?: [shares addObject:share];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, shares);
        }];
    }];
}

+ (NSURLSessionDataTask *)listShareRecipientsForFileWithID:(NSInteger)fileIdentifier callback:(void (^)(NSError * _Nullable, NSArray<PKShareRecipient *> * _Nonnull))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/shared-with", kPKEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSMutableArray *recipients = [NSMutableArray array];
        
        for (NSDictionary *sharesDictionary in [responseDictionary objectForKey:@"shared-with"]) {
            id recipient = [PKShareRecipient alloc];
            
            if ([recipient conformsToProtocol:@protocol(PKObjectProtocol)]) {
                recipient = [recipient initFromDictionary:sharesDictionary];
            }
            
            recipient == nil ?: [recipients addObject:recipient];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, recipients);
        }];
    }];
}

+ (NSURLSessionDataTask *)stopSharingFileWithID:(NSInteger)fileIdentifier withShareRecipientsWithIDs:(NSArray<NSNumber *> *)shareIdentifiers callback:(PKErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/unshare", kPKEndpointFiles, fileIdentifier]];
    
    NSString *shareValue = [shareIdentifiers containsObject:@(-1)] ? @"everyone" : [shareIdentifiers componentsJoinedByString:@","];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"shares" value:shareValue],
                              [NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    
    return [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error);
        }];
    }];
}

+ (NSURLSessionDataTask *)listSubtitlesForFileWithID:(NSInteger)fileIdentifier callback:(void (^)(NSError * _Nullable, NSArray<PKSubtitle *> * _Nonnull))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/subtitles", kPKEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSMutableArray *subtitles = [NSMutableArray array];
        
        for (NSDictionary *subtitleDictionary in [responseDictionary objectForKey:@"subtitles"]) {
            id subtitle = [PKSubtitle alloc];
            
            if ([subtitle conformsToProtocol:@protocol(PKObjectProtocol)]) {
                subtitle = [subtitle initFromDictionary:subtitleDictionary];
            }
            
            subtitle == nil ?: [subtitles addObject:subtitle];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, subtitles);
        }];
    }];
}

+ (NSURLSessionDownloadTask *)downloadSubtitleWithID:(NSString *)subtitleIdentifier
                                          withFormat:(PKSubtitleFormat)format
                                       forFileWithID:(NSInteger)fileIdentifier
                                            callback:(nonnull void (^)(NSError * _Nullable, NSURL * _Nullable))callback
{
    subtitleIdentifier = subtitleIdentifier == nil ? @"default" : subtitleIdentifier;
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/subtitles/%@", kPKEndpointFiles, fileIdentifier, subtitleIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"format" value:format],
                              [NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    return [session downloadTaskWithURL:components.URL completionHandler:^(NSURL * _Nullable location,
                                                                           NSURLResponse * _Nullable response,
                                                                           NSError * _Nullable error)
    {
        NSURL *subtitleURL;
        
        if (error == nil) {
            NSFileManager *manager = [NSFileManager defaultManager];
            NSURL *downloadsDirectoryURL = [[manager URLsForDirectory:NSDownloadsDirectory inDomains:NSUserDomainMask] firstObject];
            subtitleURL = [downloadsDirectoryURL URLByAppendingPathComponent:response.suggestedFilename];
            
            [manager moveItemAtURL:downloadsDirectoryURL toURL:subtitleURL error:&error];
            
            if (error != nil) subtitleURL = nil; // Set subtitleURL to `nil` if there was an error moving the subtitleURL so as to not confuse the developer with both a nonull "error" and "url" parameter.
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, subtitleURL);
        }];
    }];
}

+ (NSURL *)HLSURLForFileWithID:(NSInteger)fileIdentifier subtitleID:(NSString *)subtitleIdentifier {
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/hls/media.m3u8", kPKEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"subtitle_key" value:subtitleIdentifier],
                              [NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    return components.URL;
}

+ (NSURLSessionDataTask *)listEventsWithCallback:(void (^)(NSError * _Nullable, NSArray<PKEvent *> * _Nonnull))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPKEndpointListEvents];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSMutableArray *events = [NSMutableArray array];
        
        for (NSDictionary *eventDictionary in [responseDictionary objectForKey:@"events"]) {
            id event = [PKEvent alloc];
            
            if ([event conformsToProtocol:@protocol(PKObjectProtocol)]) {
                event = [event initFromDictionary:eventDictionary];
            }
            
            event == nil ?: [events addObject:event];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, events);
        }];
    }];
}

+ (NSURLSessionDataTask *)deleteAllEventsWithCallback:(PKErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPKEndpointDeleteEvents];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    
    return [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error);
        }];
    }];
}

+ (NSURLSessionDataTask *)setStartPosition:(NSTimeInterval)startPosition
                             forFileWithID:(NSInteger)fileIdentifier
                                  callback:(PKErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/start-from", kPKEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"time" value:@(startPosition).stringValue],
                              [NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    
    return [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error);
        }];
    }];
}

+ (NSURLSessionDataTask *)removeStartPositionFromFileWithID:(NSInteger)fileIdentifier callback:(PKErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/start-from/delete", kPKEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    
    return [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error);
        }];
    }];
}

@end
