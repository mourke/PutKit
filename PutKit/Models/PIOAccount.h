//
//  PIOAccount.h
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

NS_ASSUME_NONNULL_BEGIN

/**
 An account object.
 */
NS_SWIFT_NAME(Account)
@interface PIOAccount : NSObject

/** The user's username that they chose when signing up. */
@property (strong, nonatomic, readonly) NSString *username;

/** The user's email address. */
@property (strong, nonatomic, readonly) NSString *emailAddress;

/** The date on which the user's current plan expires. */
@property (strong, nonatomic, readonly) NSDate *planExpiryDate NS_SWIFT_NAME(planExpiresOn);

/** The default `ISO639-2` language code that the user has selected. */
@property (strong, nonatomic, readonly) NSString *defaultSubtitleLanguageCode;

/** The array of `ISO639-2` language codes that the user has selected to be fetched for each transfer. */
@property (strong, nonatomic, readonly) NSArray<NSString *> *subtitleLanguageCodes;

/** The user's available disk space on @b Put.io. */
@property (nonatomic, readonly) NSInteger diskSpaceAvailable;

/** The amount of disk space on @b Put.io that has been used. */
@property (nonatomic, readonly) NSInteger diskSpaceUsed;

/** The total space (both used and available) that the user has on @b Put.io, according to their subscription. */
@property (nonatomic, readonly) NSInteger totalDiskSize;

@end

NS_ASSUME_NONNULL_END
