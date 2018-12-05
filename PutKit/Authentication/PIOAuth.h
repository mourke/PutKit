//
//  PIOAuth.h
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

#import <Foundation/Foundation.h>

@class AFOAuthCredential;
@protocol PIOAuthenticatorDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 This class provides helper methods for authenticating users against the @b Put.io authentication service. In order to make any calls to the api this class must first be configured.
 
    0. Set your `apiSecret`, `clientID` and `redirectURI` obtained when registering for a new @b Put.io account. (https://app.put.io/oauth/apps/new).
    1. Register your application for the URL Scheme that is in your `redirectURI`.
    2. Add yourself as a listener to the `PIOAuthenticatorDelegate` by calling `addListener:`.
    3. Open the `signInURL` variable in some webview - `SFSafariViewController`, `Safari`, `WKWebView` etc.
    4. Pass the 'code' received from this URL into the `getCredentialForCode:callback:` method.
    5. Done! 🎉🎉. The credential will have been stored in the user's keychain for later use.
 
 @note If you want to use this class for storing credentials, - which it will do automatically - you must have keychain accessibilty turned on in your app's capabilities page.
 */
NS_SWIFT_NAME(Auth)
@interface PIOAuth : NSObject

/**
 The authentication result callback.
 
 @param error       An `NSError` object if an error occurred, is `nil` if there is no error.
 @param credential  An `AFOAuthCredential` object containing information about the session.
 */
typedef void (^PIOAuthCallback)(NSError * _Nullable error, AFOAuthCredential * _Nullable credential);

/**
 The de-authentication result callback.
 
 @param error       An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^PIOSignOutCallback)(NSError * _Nullable error);

/**
 Shared singleton instance of the `PIOAuth` class. A separate instance is not necessary and is not to be created.
 */
+ (PIOAuth *)sharedInstance NS_SWIFT_NAME(shared());

/**
 Signs the object up to recieve `PIOAuthenticatorDelegate` requests, if the object has not already been signed up.
 
 @param listener    The object to be signed up for delegate requests.
 */
- (void)addListener:(id<PIOAuthenticatorDelegate>)listener;

/**
 Resigns the specified object from `PIOAuthenticatorDelegate` delegate requests.
 
 @param listener    The object to be resigned from delegate requests.
 */
- (void)removeListener:(id<PIOAuthenticatorDelegate>)listener;

/**
 The first step in user authentication.  Returns the sign in URL to which the user should be navigated in order to complete the rest of the authentication process. Upon visiting this URL and successfully logging in, a 'code' will be passed into the application. This code must be passed to the `credentialForCode:callback:` method to finish authentication.
 */
@property (strong, nonatomic, readonly) NSURL *signInURL;

/**
 The last step in user authentication.
 
 Returns and stores the `AFOAuthCredential` object in the user's keychain. This can later be accessed by the `credential` property.
 
 @param code        The code received from the first part of the authentication process
 @param callback    The block called when the request completes. If the request completes successfully, an `AFOAuthCredential` will be returned, however, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
- (NSURLSessionDataTask *)getCredentialForCode:(NSString *)code callback:(PIOAuthCallback _Nullable)callback NS_SWIFT_NAME(credential(for:callback:));

/**
 Locally and remotely removes the user's access token.
 
 @param callback    The block called when the request completes. If the request fails, the underlying error will be returned, otherwise, this parameter will be `nil`.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
- (NSURLSessionDataTask *)signOutAndRevokeAccessTokenWithCallback:(PIOSignOutCallback _Nullable)callback;

/**
 Your "CLIENT ID" obtained from @b Put.io.
 
 @warning This property @b MUST be set before @b ANY calls are made to @b ANY method on this class otherwise an exception will be raised.
 */
@property (strong, nonatomic) NSString *clientID NS_SWIFT_NAME(clientId);

/**
 Your "APPLICATION SECRET" obtained from @b Put.io.
 
 @warning This property @b MUST be set before @b ANY calls are made to @b ANY method on this class otherwise an exception will be raised.
 */
@property (strong, nonatomic) NSString *APISecret NS_SWIFT_NAME(apiSecret);

/**
 Your "CALLBACK URL" obtained from @b Put.io.
 
 @warning This property @b MUST be set before @b ANY calls are made to @b ANY method on this class otherwise an exception will be raised.
 */
@property (strong, nonatomic) NSURL *redirectURI;

/** A boolean value indicating whether the user has authenticated or not. */
@property (nonatomic, readonly, getter=isUserAuthenticated) BOOL userAuthenticated;

/** The OAuth credential retrieved from a successful authentication, if any */
@property (strong, nonatomic, nullable, readonly) AFOAuthCredential *credential;

@end

NS_ASSUME_NONNULL_END
