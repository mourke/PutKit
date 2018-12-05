//
//  PIOAPI+Files.m
//  PutKit
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

#import "PIOAPI+Files.h"
#import "PIOError.h"
#import "PIOEndpoints.h"
#import "PIOFile.h"
#import "PIOObjectProtocol.h"
#import "PIOTransfer.h"
#import "PIOAuth.h"
#import "AFOAuthCredential.h"
#import "PIOMP4Conversion.h"
#import "PIOShare.h"
#import "PIOShareRecipient.h"
#import "PIOSubtitle.h"
#import "PIOEvent.h"

@implementation PIOAPI (Files)

+ (NSURLSessionDataTask *)listFilesInFolderWithID:(NSInteger)folderIdentifier
                                         callback:(void (^)(NSError * _Nullable, NSArray<PIOFile *> * _Nonnull, PIOFile * _Nullable))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointListFiles];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"parent_id" value:@(folderIdentifier).stringValue],
                              [NSURLQueryItem queryItemWithName:@"oauth_token" value:[PIOAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error) {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = data ? error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
        
        NSMutableArray *files = [NSMutableArray array];
        
        for (NSDictionary *filesDictionary in [responseDictionary objectForKey:@"files"]) {
            id file = [PIOFile alloc];
            
            if ([file conformsToProtocol:@protocol(PIOObjectProtocol)]) {
                file = [file initFromDictionary:filesDictionary];
                
                file == nil ?: [files addObject:file];
            }
        }
        
        id parent = [PIOFile alloc];
        
        if ([parent conformsToProtocol:@protocol(PIOObjectProtocol)]) {
            parent = [parent initFromDictionary:[responseDictionary objectForKey:@"parent"]];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, files, parent);
        }];
    }];
}

+ (NSURLSessionDataTask *)searchFilesWithQuery:(NSString *)query
                                        onPage:(NSInteger)page
                                      callback:(void (^)(NSError * _Nullable, NSArray<PIOFile *> * _Nonnull, NSURL * _Nullable))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[kPIOEndpointSearchFiles stringByAppendingFormat:@"/%@/page/%@", [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], @(page).stringValue]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token" value:[PIOAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error) {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = data ? error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
        
        NSMutableArray *files = [NSMutableArray array];
        
        for (NSDictionary *filesDictionary in [responseDictionary objectForKey:@"files"]) {
            id file = [PIOFile alloc];
            
            if ([file conformsToProtocol:@protocol(PIOObjectProtocol)]) {
                file = [file initFromDictionary:filesDictionary];
                
                file == nil ?: [files addObject:file];
            }
        }
        

        NSString *nextPageString = [responseDictionary objectForKey:@"next"];
        NSURL *nextPageURL = [nextPageString isKindOfClass:NSString.class] ? [NSURL URLWithString:nextPageString] : nil;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, files, nextPageURL);
        }];
    }];
}

+ (NSURLSessionUploadTask *)uploadFileAtURL:(NSURL *)fileURL
                             toFolderWithID:(NSInteger)parentIdentifier
                                newFileName:(NSString * _Nullable)fileName
                                   callback:(void (^)(NSError * _Nullable, PIOFile * _Nullable))callback {
    NSAssert(![[fileURL pathExtension] isEqualToString:@".torrent"], @"Please use `uploadTorrentFileAtURL:toFolderWithID:newFileName:callback:` instead.");
    
    if (fileName == nil) fileName = [fileURL lastPathComponent];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kPIOEndpointUploadFiles]];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    return [session uploadTaskWithRequest:request fromFile:fileURL
                        completionHandler:^(NSData * _Nullable data,
                                            NSURLResponse * _Nullable response,
                                            NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = data ? error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
        
        id file = [PIOFile alloc];
        
        if ([file conformsToProtocol:@protocol(PIOObjectProtocol)]) {
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
                                          callback:(void (^)(NSError * _Nullable, PIOTransfer * _Nullable))callback {
    NSAssert([[torrentURL pathExtension] isEqualToString:@".torrent"], @"Please use `uploadFileAtURL:toFolderWithID:newFileName:callback:` instead.");
    
    if (fileName == nil) fileName = [torrentURL lastPathComponent];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kPIOEndpointUploadFiles]];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    return [session uploadTaskWithRequest:request fromFile:torrentURL
                        completionHandler:^(NSData * _Nullable data,
                                            NSURLResponse * _Nullable response,
                                            NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = data ? error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
        
        id transfer = [PIOTransfer alloc];
        
        if ([transfer conformsToProtocol:@protocol(PIOObjectProtocol)]) {
            transfer = [transfer initFromDictionary:[responseDictionary objectForKey:@"transfer"]];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, transfer);
        }];
    }];
}

+ (NSURLSessionDataTask *)createFolderNamed:(NSString *)folderName
                          inDirectoryWithID:(NSInteger)parentIdentifier
                                   callback:(PIOErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointCreateFolder];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token" value:[PIOAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{@"name" : folderName,
                                                                 @"parent_id" : @(parentIdentifier).stringValue}
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    
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

+ (NSURLSessionDataTask *)getFileForID:(NSInteger)fileIdentifier callback:(void (^)(NSError * _Nullable, PIOFile * _Nullable))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd", kPIOEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token" value:[PIOAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error) {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = data ? error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
        
        id file = [PIOFile alloc];
        
        if ([file conformsToProtocol:@protocol(PIOObjectProtocol)]) {
            file = [file initFromDictionary:[responseDictionary objectForKey:@"file"]];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, file);
        }];
    }];
}

+ (NSURLSessionDataTask *)deleteFilesWithIDs:(NSArray<NSNumber *> *)fileIdentifiers
                                    callback:(PIOErrorOnlyCallback)callback {
    NSParameterAssert(fileIdentifiers.count > 0);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointDeleteFiles];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token" value:[PIOAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{@"file_ids" : [fileIdentifiers componentsJoinedByString:@","]}
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    
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
                                  callback:(PIOErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointRenameFile];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token" value:[PIOAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{@"file_id" : @(fileIdentifier).stringValue}
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    
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
                                  callback:(PIOErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointMoveFile];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token" value:[PIOAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{@"file_ids" : [fileIdentifiers componentsJoinedByString:@","],
                                                                 @"parent_id" : @(destinationIdentifier).stringValue}
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    
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
                                                callback:(PIOErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/mp4", kPIOEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
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
                                                     callback:(void (^)(NSError * _Nullable, PIOMP4Conversion *  _Nullable))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/mp4", kPIOEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = data ? error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
        
        id status = [PIOMP4Conversion alloc];
        
        if ([status conformsToProtocol:@protocol(PIOObjectProtocol)]) {
            status = [status initFromDictionary:[responseDictionary objectForKey:@"mp4"]];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, status);
        }];
    }];
}

+ (NSURLSessionDownloadTask *)downloadFileForID:(NSInteger)fileIdentifier callback:(void (^)(NSError * _Nullable, NSURL * _Nullable))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/download", kPIOEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
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
                                   callback:(PIOErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointShareFiles];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{@"file_ids" : [fileIdentifiers componentsJoinedByString:@","],
                                                                 @"friends" : [friends componentsJoinedByString:@","]}
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    
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

+ (NSURLSessionDataTask *)listSharesWithCallback:(void (^)(NSError * _Nullable, NSArray<PIOShare *> * _Nonnull))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointSharedFiles];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = data ? error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
        
        NSMutableArray *shares = [NSMutableArray array];
        
        for (NSDictionary *sharesDictionary in [responseDictionary objectForKey:@"shared"]) {
            id share = [PIOShare alloc];
            
            if ([share conformsToProtocol:@protocol(PIOObjectProtocol)]) {
                share = [share initFromDictionary:sharesDictionary];
            }
            
            share == nil ?: [shares addObject:share];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, shares);
        }];
    }];
}

+ (NSURLSessionDataTask *)listShareRecipientsForFileWithID:(NSInteger)fileIdentifier callback:(void (^)(NSError * _Nullable, NSArray<PIOShareRecipient *> * _Nonnull))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/shared-with", kPIOEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = data ? error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
        
        NSMutableArray *recipients = [NSMutableArray array];
        
        for (NSDictionary *sharesDictionary in [responseDictionary objectForKey:@"shared-with"]) {
            id recipient = [PIOShareRecipient alloc];
            
            if ([recipient conformsToProtocol:@protocol(PIOObjectProtocol)]) {
                recipient = [recipient initFromDictionary:sharesDictionary];
            }
            
            recipient == nil ?: [recipients addObject:recipient];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, recipients);
        }];
    }];
}

+ (NSURLSessionDataTask *)stopSharingFileWithID:(NSInteger)fileIdentifier withShareRecipientsWithIDs:(NSArray<NSNumber *> *)shareIdentifiers callback:(PIOErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/unshare", kPIOEndpointFiles, fileIdentifier]];
    
    NSString *shareValue = [shareIdentifiers containsObject:@(-1)] ? @"everyone" : [shareIdentifiers componentsJoinedByString:@","];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{@"shares" : shareValue}
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    
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

+ (NSURLSessionDataTask *)listSubtitlesForFileWithID:(NSInteger)fileIdentifier callback:(void (^)(NSError * _Nullable, NSArray<PIOSubtitle *> * _Nonnull))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/subtitles", kPIOEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = data ? error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
        
        NSMutableArray *subtitles = [NSMutableArray array];
        
        for (NSDictionary *subtitleDictionary in [responseDictionary objectForKey:@"subtitles"]) {
            id subtitle = [PIOSubtitle alloc];
            
            if ([subtitle conformsToProtocol:@protocol(PIOObjectProtocol)]) {
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
                                          withFormat:(PIOSubtitleFormat)format
                                       forFileWithID:(NSInteger)fileIdentifier
                                            callback:(nonnull void (^)(NSError * _Nullable, NSURL * _Nullable))callback
{
    subtitleIdentifier = subtitleIdentifier == nil ? @"default" : subtitleIdentifier;
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/subtitles/%@", kPIOEndpointFiles, fileIdentifier, subtitleIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"format" value:format],
                              [NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
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
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/hls/media.m3u8", kPIOEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"subtitle_key" value:subtitleIdentifier],
                              [NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    return components.URL;
}

+ (NSURLSessionDataTask *)listEventsWithCallback:(void (^)(NSError * _Nullable, NSArray<PIOEvent *> * _Nonnull))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointListEvents];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = data ? error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
        
        NSMutableArray *events = [NSMutableArray array];
        
        for (NSDictionary *eventDictionary in [responseDictionary objectForKey:@"events"]) {
            id event = [PIOEvent alloc];
            
            if ([event conformsToProtocol:@protocol(PIOObjectProtocol)]) {
                event = [event initFromDictionary:eventDictionary];
            }
            
            event == nil ?: [events addObject:event];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, events);
        }];
    }];
}

+ (NSURLSessionDataTask *)deleteAllEventsWithCallback:(PIOErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointDeleteEvents];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
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
                                  callback:(PIOErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/start-from", kPIOEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"time" value:@(startPosition).stringValue],
                              [NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
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

+ (NSURLSessionDataTask *)removeStartPositionFromFileWithID:(NSInteger)fileIdentifier callback:(PIOErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd/start-from/delete", kPIOEndpointFiles, fileIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
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
