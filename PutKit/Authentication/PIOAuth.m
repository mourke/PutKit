//
//  PIOAuth.m
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

#import "PIOAuth.h"
#import "PIOEndpoints.h"
#import "PIOAuthenticatorDelegate.h"
#import "AFOAuthCredential.h"
#import "PIOError.h"

NSString * const kPIOOAuthCredentialIdentifier = @"PutKitCredential";

@interface PIOAuth()

@property (strong, nonatomic, nonnull) NSHashTable<id<PIOAuthenticatorDelegate>> *listeners;

@end

@implementation PIOAuth

+ (PIOAuth *)sharedInstance {
    static PIOAuth *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [PIOAuth new];
    });
    return sharedInstance;
}

- (void)addListener:(id<PIOAuthenticatorDelegate>)listener {
    if (![_listeners containsObject:listener]) {
        [_listeners addObject:listener];
    }
}

- (void)removeListener:(id<PIOAuthenticatorDelegate>)listener {
    [_listeners removeObject:listener];
}

- (AFOAuthCredential *)credential {
    return [AFOAuthCredential retrieveCredentialWithIdentifier:kPIOOAuthCredentialIdentifier];
}

- (NSString *)APISecret {
    NSAssert(_APISecret != nil, @"API secret must be set before any calls to this class are made.");
    return _APISecret;
}

- (NSString *)clientID {
    NSAssert(_clientID != nil, @"Client ID must be set before any calls to this class are made.");
    return _clientID;
}

- (NSURL *)redirectURI {
    NSAssert(_redirectURI != nil, @"Redirect URI must be set before any calls to this class are made.");
    return _redirectURI;
}

- (BOOL)isUserAuthenticated {
    return [self credential] != nil;
}

- (BOOL)signOut {
    return [AFOAuthCredential deleteCredentialWithIdentifier:kPIOOAuthCredentialIdentifier];
}

- (NSURL *)signInURL {
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointAuthenticate];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"client_id" value:_clientID],
                              [NSURLQueryItem queryItemWithName:@"response_type" value:@"code"],
                              [NSURLQueryItem queryItemWithName:@"redirect_uri" value:_redirectURI.absoluteString]];
    return components.URL;
}

- (NSURLSessionDataTask *)getCredentialForCode:(NSString *)code callback:(PIOAuthCallback)callback {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        for (id<PIOAuthenticatorDelegate> delegate in [[self listeners] allObjects]) {
            [delegate authenticationDidStart];
        }
    }];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:kPIOEndpointAuthenticate];
    
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"client_id" value:_clientID],
                              [NSURLQueryItem queryItemWithName:@"grant_type" value:@"authorization_code"],
                              [NSURLQueryItem queryItemWithName:@"code" value:code],
                              [NSURLQueryItem queryItemWithName:@"redirect_uri" value:_redirectURI.absoluteString]];

    return [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error) {
        pk_response_validate(data, &error);
        
        NSDictionary *responseDictionary = error ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSString *token = responseDictionary[@"access_token"];
    
        if (token != nil) {
            [[AFOAuthCredential credentialWithOAuthToken:token tokenType:@"Bearer"] storeWithIdentifier:kPIOOAuthCredentialIdentifier];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(error, [self credential]);
            for (id<PIOAuthenticatorDelegate> delegate in [_listeners allObjects]) {
                [delegate authenticationDidFinishWithError:error];
            }
        }];
    }];
}

@end
