//
//  PIOAuthenticatorDelegate.h
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

#import <Foundation/NSObject.h>

@class NSError;

/**
 This class provides information about the success of the authentication request. All methods are _required_ and therefore must be implemented.
 */
NS_SWIFT_NAME(AuthenticatorDelegate)
@protocol PIOAuthenticatorDelegate <NSObject>

@optional
/**
 Called right before the OAuth initiation process starts.
 */
- (void)authenticationDidStart;

/**
 Called right after a response has been received from the OAuth API.
 
 @param error   If the request fails, the reason for failure will be supplied. If this property is `nil`, the request has completed successfully.
 */
- (void)authenticationDidFinishWithError:(NSError * _Nullable)error;

@end
