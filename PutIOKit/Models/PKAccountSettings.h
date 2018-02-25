//
//  PKAccountSettings.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 An account settings object.
 */
NS_SWIFT_NAME(AccountSettings)
@interface PKAccountSettings : NSObject

/** The file identifier of the user's default download folder. `0` is the root folder. */
@property (nonatomic, readonly) NSInteger defaultDownloadFolderIdentifier;

/** A boolean value indicating whether the user is invisible to other users in searches or not. */
@property (nonatomic, readonly, getter=isInvisible) BOOL invisible;

/** The default `ISO639-2` language code that the user has selected. This is automatically selected as the first object of the  `subtitleLanguageCodes` array. */
@property (strong, nonatomic, readonly) NSString *defaultSubtitleLanguageCode;

/** The array of `ISO639-2` language codes that the user has selected to be fetched for each transfer. */
@property (strong, nonatomic, readonly) NSArray<NSString *> *subtitleLanguageCodes;

/**
 Creates a new `PKAccountSettings` object for posting to @b Put.io.
 
 @param defaultDownloadFolderIdentifier The file identifier of the user's default download folder. `0` is the root folder.
 @param isInvisible                     A boolean value indicating whether the user is invisible to other users in searches or not.
 @param subtitleLanguageCodes           An array of `ISO639-2` language codes to be fetched for each transfer. @b MAXIMUM of @b 2 languages. If there are more, an exception will be raised.
 
 @return    A new `PKAccountSettings` object.
 */
- (instancetype)initWithDefaultDownloadFolderIdentifier:(NSInteger)defaultDownloadFolderIdentifier
                                            isInvisible:(BOOL)isInvisible
                                  subtitleLanguageCodes:(NSArray<NSString *> *)subtitleLanguageCodes;

@end

NS_ASSUME_NONNULL_END
