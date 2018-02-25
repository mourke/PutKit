//
//  PIOAPI+Account.h
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
#import "PIOAPI.h"
#import "PIOErrorOnlyCallback.h"

@class PIOAccount, PIOAccountSettings;

NS_ASSUME_NONNULL_BEGIN

@interface PIOAPI (Account)

/**
 Returns information about a user account.
 
 @param callback    The block that is called when the request completes. If the request completes successfully, a `PIOAccount` object will be returned. However, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)getAccountInformationWithCallback:(void (^)(NSError * _Nullable, PIOAccount * _Nullable))callback NS_SWIFT_NAME(accountInformation(_:));

/**
 Returns the user's preferences.
 
 @param callback    The block that is called when the request completes. If the request completes successfully, a `PIOAccountSettings` object will be returned. However, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)getAccountSettingsWithCallback:(void (^)(NSError * _Nullable, PIOAccountSettings * _Nullable))callback NS_SWIFT_NAME(accountSettings(_:));

/**
 Updates user preferences.
 
 @param newAccountSettings  The account settings the user wishes to have.
 @param callback            The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 */
+ (NSURLSessionDataTask *)updateAccountSettings:(PIOAccountSettings *)newAccountSettings callback:(PIOErrorOnlyCallback _Nullable)callback NS_SWIFT_NAME(updateAccountSettings(new:callback:));

@end

NS_ASSUME_NONNULL_END
