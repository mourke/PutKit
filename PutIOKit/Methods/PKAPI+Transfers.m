//
//  PKAPI+Transfers.m
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

#import "PKAPI+Transfers.h"
#import "PKError.h"
#import "PKEndpoints.h"
#import "PKObjectProtocol.h"
#import "PKTransfer.h"
#import "PKAuth.h"
#import "AFOAuthCredential.h"

@implementation PKAPI (Transfers)

+ (NSURLSessionDataTask *)listActiveTransfersWithCallback:(void (^)(NSError * _Nullable, NSArray<PKTransfer *> * _Nonnull))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPKEndpointListTransfers];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSMutableArray *transfers = [NSMutableArray array];
        
        for (NSDictionary *transferDictionary in [responseDictionary objectForKey:@"transfers"]) {
            id transfer = [PKTransfer alloc];
            
            if ([transfer conformsToProtocol:@protocol(PKObjectProtocol)]) {
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
                                    callback:(void (^)(NSError * _Nullable, PKTransfer * _Nullable))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPKEndpointAddTransfer];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"url" value:URL.absoluteString],
                              [NSURLQueryItem queryItemWithName:@"save_parent_id" value:@(parentIdentifier).stringValue],
                              [NSURLQueryItem queryItemWithName:@"callback_url" value:callbackURL.absoluteString],
                              [NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setHTTPMethod:@"POST"];
    
    return [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        id transfer = [PKTransfer alloc];
        
        if ([transfer conformsToProtocol:@protocol(PKObjectProtocol)]) {
            transfer = [transfer initFromDictionary:responseDictionary];
        } else {
            transfer = nil;
        }
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, transfer);
        }];
    }];
}

+ (NSURLSessionDataTask *)getTransferForID:(NSInteger)transferIdentifier callback:(void (^)(NSError * _Nullable, PKTransfer * _Nullable))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%zd", kPKEndpointTransfers, transferIdentifier]];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        id transfer = [PKTransfer alloc];
        
        if ([transfer conformsToProtocol:@protocol(PKObjectProtocol)]) {
            transfer = [transfer initFromDictionary:responseDictionary];
        } else {
            transfer = nil;
        }
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, transfer);
        }];
    }];
}

+ (NSURLSessionDataTask *)retryTransferWithIdentifier:(NSInteger)transferIdentifier callback:(PKErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPKEndpointRetryTransfer];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"id" value:@(transferIdentifier).stringValue],
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

+ (NSURLSessionDataTask *)cancelTransfersWithIdentifiers:(NSArray<NSNumber *> *)transferIdentifiers callback:(PKErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPKEndpointCancelTransfer];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"transfer_ids"
                                                          value:[transferIdentifiers componentsJoinedByString:@","]],
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

+ (NSURLSessionDataTask *)cleanCompletedTransfersWithCallback:(PKErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPKEndpointAddTransfer];
    
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
