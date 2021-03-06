//
//  PIOAPI+Friends.m
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

#import "PIOAPI+Friends.h"
#import "PIOError.h"
#import "PIOEndpoints.h"
#import "PIOObjectProtocol.h"
#import "PIOFriend.h"
#import "PIOAuth.h"
#import "AFOAuthCredential.h"

@implementation PIOAPI (Friends)

+ (NSURLSessionDataTask *)listFriendsWithCallback:(void (^)(NSError * _Nullable, NSArray<PIOFriend *> * _Nonnull))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointListFriends];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = data ? error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
        
        NSMutableArray *friends = [NSMutableArray array];
        
        for (NSDictionary *friendDictionary in [responseDictionary objectForKey:@"friends"]) {
            id friend = [PIOFriend alloc];
            
            if ([friend conformsToProtocol:@protocol(PIOObjectProtocol)]) {
                friend = [friend initFromDictionary:friendDictionary];
                
                friend == nil ?: [friends addObject:friend];
            }
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, friends);
        }];
    }];
}

+ (NSURLSessionDataTask *)getFriendRequestsWithCallback:(void (^)(NSError * _Nullable, NSArray<PIOFriend *> * _Nonnull))callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointFriendRequests];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"oauth_token"
                                                          value:[PIOAuth sharedInstance].credential.accessToken]];
    
    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error)
    {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = data ? error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
        
        NSMutableArray *friends = [NSMutableArray array];
        
        for (NSDictionary *friendDictionary in [responseDictionary objectForKey:@"friends"]) {
            id friend = [PIOFriend alloc];
            
            if ([friend conformsToProtocol:@protocol(PIOObjectProtocol)]) {
                friend = [friend initFromDictionary:friendDictionary];
                
                friend == nil ?: [friends addObject:friend];
            }
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, friends);
        }];
    }];
}

+ (NSURLSessionDataTask *)sendFriendRequestToFriendNamed:(NSString *)username callback:(PIOErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%@/request", kPIOEndpointFriends, username]];
    
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
            if (callback != nil) callback(error);
        }];
    }];
}
                                   
+ (NSURLSessionDataTask *)approveFriendRequestFromFriendNamed:(NSString *)username callback:(PIOErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%@/approve", kPIOEndpointFriends, username]];
    
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
            if (callback != nil) callback(error);
        }];
    }];
}

+ (NSURLSessionDataTask *)denyFriendRequestFromFriendNamed:(NSString *)username callback:(PIOErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%@/deny", kPIOEndpointFriends, username]];
    
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
            if (callback != nil) callback(error);
        }];
    }];
}

+ (NSURLSessionDataTask *)unfriendFriendRequestFromFriendNamed:(NSString *)username callback:(PIOErrorOnlyCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%@/unfriend", kPIOEndpointFriends, username]];
    
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
            if (callback != nil) callback(error);
        }];
    }];
}

@end
