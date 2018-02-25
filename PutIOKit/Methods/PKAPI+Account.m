//
//  PKAPI+Account.m
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

#import "PKAPI+Account.h"
#import "PKError.h"
#import "PKEndpoints.h"
#import "PKObjectProtocol.h"
#import "PKAccount.h"
#import "PKAccountSettings.h"
#import "PKAuth.h"
#import "AFOAuthCredential.h"

@implementation PKAPI (Account)

+ (NSURLSessionDataTask *)getAccountInformationWithCallback:(void (^)(NSError * _Nullable, PKAccount * _Nullable))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPKEndpointAccountInfo];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        id account = [PKAccount alloc];
        
        if ([account conformsToProtocol:@protocol(PKObjectProtocol)]) {
            account = [account initFromDictionary:[responseDictionary objectForKey:@"info"]];
        } else {
            account = nil;
        }
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, account);
        }];
    }];
}

+ (NSURLSessionDataTask *)getAccountSettingsWithCallback:(void (^)(NSError * _Nullable, PKAccountSettings * _Nullable))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPKEndpointAccountSettings];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PKAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        id settings = [PKAccountSettings alloc];
        
        if ([settings conformsToProtocol:@protocol(PKObjectProtocol)]) {
            settings = [settings initFromDictionary:[responseDictionary objectForKey:@"settings"]];
        } else {
            settings = nil;
        }
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, settings);
        }];
    }];
}

+ (NSURLSessionDataTask *)updateAccountSettings:(PKAccountSettings *)newAccountSettings callback:(PKErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPKEndpointAccountSettings];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"default_download_folder" value:@(newAccountSettings.defaultDownloadFolderIdentifier).stringValue],
                              [NSURLQueryItem queryItemWithName:@"is_invisible"
                                                          value:newAccountSettings.isInvisible ? @"true" : @"false"],
                              [NSURLQueryItem queryItemWithName:@"subtitle_languages"
                                                          value:[newAccountSettings.subtitleLanguageCodes componentsJoinedByString:@","]],
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

@end
