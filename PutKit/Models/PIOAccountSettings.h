//
//  PIOAccountSettings.h
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
 An account settings object.
 */
NS_SWIFT_NAME(AccountSettings)
@interface PIOAccountSettings : NSObject

/** The file identifier of the user's default download folder. `0` is the root folder. May be `NaN`. */
@property (nonatomic, readonly) NSInteger defaultDownloadFolderIdentifier;

/** A boolean value indicating whether the user is invisible to other users in searches or not. May be `[NSNull null]`. */
@property (nonatomic, readonly, getter=isInvisible) BOOL invisible;

/** The default `ISO639-2` language code that the user has selected. This is automatically selected as the first object of the  `subtitleLanguageCodes` array. */
@property (strong, nonatomic, readonly, nullable) NSString *defaultSubtitleLanguageCode;

/** The array of `ISO639-2` language codes that the user has selected to be fetched for each transfer. */
@property (strong, nonatomic, readonly, nullable) NSArray<NSString *> *subtitleLanguageCodes;

/**
 Creates a new `PIOAccountSettings` object for posting to @b Put.io.
 
 @param defaultDownloadFolderIdentifier The file identifier of the user's default download folder. `0` is the root folder.
 @param subtitleLanguageCodes   An array of `ISO639-2` language codes to be fetched for each transfer. @b MAXIMUM of @b 2 languages. If there are more, an exception will be raised. Passing `nil` will not change the server-side value; passing an empty array will.
 @param isInvisible             A boolean value indicating whether the user is invisible to other users in searches or not.
 
 @return    A new `PIOAccountSettings` object.
 */
- (instancetype)initWithDefaultDownloadFolderIdentifier:(NSInteger)defaultDownloadFolderIdentifier
                                  subtitleLanguageCodes:(NSArray<NSString *> * _Nullable)subtitleLanguageCodes
                                            isInvisible:(BOOL)isInvisible NS_DESIGNATED_INITIALIZER;

/**
 Creates a new `PIOAccountSettings` object for posting to @b Put.io.
 
 @param defaultDownloadFolderIdentifier The file identifier of the user's default download folder. `0` is the root folder.
 @param isInvisible                     A boolean value indicating whether the user is invisible to other users in searches or not.
 
 @return    A new `PIOAccountSettings` object.
 */
- (instancetype)initWithDefaultDownloadFolderIdentifier:(NSInteger)defaultDownloadFolderIdentifier
                                            isInvisible:(BOOL)isInvisible;

/**
 Creates a new `PIOAccountSettings` object for posting to @b Put.io.
 
 @param defaultDownloadFolderIdentifier The file identifier of the user's default download folder. `0` is the root folder.
 @param subtitleLanguageCodes           An array of `ISO639-2` language codes to be fetched for each transfer. @b MAXIMUM of @b 2 languages. If there are more, an exception will be raised. Passing `nil` will not change the server-side value; passing an empty array will.
 
 @return    A new `PIOAccountSettings` object.
 */
- (instancetype)initWithDefaultDownloadFolderIdentifier:(NSInteger)defaultDownloadFolderIdentifier
                                  subtitleLanguageCodes:(NSArray<NSString *> * _Nullable)subtitleLanguageCodes;

/**
 Creates a new `PIOAccountSettings` object for posting to @b Put.io.
 
 @param subtitleLanguageCodes           An array of `ISO639-2` language codes to be fetched for each transfer. @b MAXIMUM of @b 2 languages. If there are more, an exception will be raised. Passing `nil` will not change the server-side value; passing an empty array will.
 @param isInvisible                     A boolean value indicating whether the user is invisible to other users in searches or not.
 
 @return    A new `PIOAccountSettings` object.
 */
- (instancetype)initWithSubtitleLanguageCodes:(NSArray<NSString *> * _Nullable)subtitleLanguageCodes
                                  isInvisible:(BOOL)isInvisible;

/**
 Creates a new `PIOAccountSettings` object for posting to @b Put.io.
 
 @param defaultDownloadFolderIdentifier The file identifier of the user's default download folder. `0` is the root folder.
 
 @return    A new `PIOAccountSettings` object.
 */
- (instancetype)initWithDefaultDownloadFolderIdentifier:(NSInteger)defaultDownloadFolderIdentifier;

/**
 Creates a new `PIOAccountSettings` object for posting to @b Put.io.
 
 @param subtitleLanguageCodes   An array of `ISO639-2` language codes to be fetched for each transfer. @b MAXIMUM of @b 2 languages. If there are more, an exception will be raised. Passing `nil` will not change the server-side value; passing an empty array will.
 
 @return    A new `PIOAccountSettings` object.
 */
- (instancetype)initWithSubtitleLanguageCodes:(NSArray<NSString *> * _Nullable)subtitleLanguageCodes;

/**
 Creates a new `PIOAccountSettings` object for posting to @b Put.io.
 
 @param isInvisible A boolean value indicating whether the user is invisible to other users in searches or not.
 
 @return    A new `PIOAccountSettings` object.
 */
- (instancetype)initWithIsInvisible:(BOOL)isInvisible;

@end

NS_ASSUME_NONNULL_END
