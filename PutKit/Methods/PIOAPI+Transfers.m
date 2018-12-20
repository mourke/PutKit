//
//  PIOAPI+Transfers.m
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

#import "PIOAPI+Transfers.h"
#import "PIOError.h"
#import "PIOEndpoints.h"
#import "PIOObjectProtocol.h"
#import "PIOTransfer.h"
#import "PIOAuth.h"
#import "AFOAuthCredential.h"

@implementation PIOAPI (Transfers)

+ (NSURLSessionDataTask *)listActiveTransfersWithCallback:(void (^)(NSError * _Nullable, NSArray<PIOTransfer *> * _Nonnull))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointListTransfers];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = data ? error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
        
        NSMutableArray *transfers = [NSMutableArray array];
        
        for (NSDictionary *transferDictionary in [responseDictionary objectForKey:@"transfers"]) {
            id transfer = [PIOTransfer alloc];
            
            if ([transfer conformsToProtocol:@protocol(PIOObjectProtocol)]) {
                transfer = [transfer initFromDictionary:transferDictionary];
                
                transfer == nil ?: [transfers addObject:transfer];
            }
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, transfers);
        }];
    }];
}

+ (NSURLSessionDataTask *)addTransferWithURL:(NSURL *)URL
                        saveFolderIdentifier:(NSInteger)parentIdentifier
                                 callbackURL:(NSURL *)callbackURL
                                    callback:(void (^)(NSError * _Nullable, PIOTransfer * _Nullable))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointAddTransfer];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:@{@"url" : URL.absoluteString, @"save_parent_id" : @(parentIdentifier).stringValue}];
    
    if (callbackURL != nil) [body setObject:@"callback_url" forKey:callbackURL.absoluteString];
    
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:nil];
    
    return [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
                
        NSDictionary *responseDictionary = data ? error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
                
        id transfer = [PIOTransfer alloc];
                
        if ([transfer conformsToProtocol:@protocol(PIOObjectProtocol)]) {
            transfer = [transfer initFromDictionary:responseDictionary[@"transfer"]];
        } else {
            transfer = nil;
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, transfer);
        }];
    }];
}

+ (NSURLSessionDataTask *)getTransferForID:(NSInteger)transferIdentifier
                             errorCallback:(PIOErrorOnlyCallback)errorCallback
                          progressCallback:(void (^)(NSError * _Nullable, PIOTransfer * _Nullable))progressCallback
                        completionCallback:(void (^)(PIOTransfer * _Nonnull))completionCallback {
    return [self getTransferForID:transferIdentifier callback:^(NSError * _Nullable error,
                                                                PIOTransfer * _Nullable transfer) {
        if (transfer == nil) return errorCallback(error);
        
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [[PIOAPI getTransferForID:((PIOTransfer *)transfer).identifier
                             callback:^(NSError *error, PIOTransfer *transfer)
              {
                  if ([transfer.status isEqualToString:PIOTransferStatusCompleted]) {
                      [timer invalidate];
                      if (completionCallback != nil) completionCallback(transfer);
                  } else {
                      if (progressCallback != nil) progressCallback(error, transfer);
                  }
              }] resume];
        }];
    }];
}

+ (NSURLSessionDataTask *)getTransferForID:(NSInteger)transferIdentifier callback:(void (^)(NSError * _Nullable, PIOTransfer * _Nullable))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd", kPIOEndpointTransfers, transferIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = data ? error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
        
        id transfer = [PIOTransfer alloc];
        
        if ([transfer conformsToProtocol:@protocol(PIOObjectProtocol)]) {
            transfer = [transfer initFromDictionary:responseDictionary[@"transfer"]];
        } else {
            transfer = nil;
        }
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, transfer);
        }];
    }];
}

+ (NSURLSessionDataTask *)retryTransferWithIdentifier:(NSInteger)transferIdentifier callback:(PIOErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointRetryTransfer];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{@"id" : @(transferIdentifier).stringValue}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
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

+ (NSURLSessionDataTask *)cancelTransfersWithIdentifiers:(NSArray<NSNumber *> *)transferIdentifiers callback:(PIOErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointCancelTransfer];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{@"transfer_ids" : [transferIdentifiers componentsJoinedByString:@","]}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
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

+ (NSURLSessionDataTask *)cleanCompletedTransfersWithCallback:(PIOErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointCleanTransfers];
    
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
