//
//  PIOAccountSettings.m
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

#import "PIOAccountSettings.h"
#import "PIOObjectProtocol.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types" // when using the BOOL value `isInvisible`, it being `NSNull` triggers different behavior. This is done because you cannot pass nil to a non object type in objective-c.

@interface PIOAccountSettings() <PIOObjectProtocol>

@end

@implementation PIOAccountSettings

- (instancetype)initWithDefaultDownloadFolderIdentifier:(NSInteger)defaultDownloadFolderIdentifier
                                  subtitleLanguageCodes:(NSArray<NSString *> *)subtitleLanguageCodes
                                            isInvisible:(BOOL)isInvisible {
    NSParameterAssert(subtitleLanguageCodes.count <= 2);
    
    self = [super init];
    
    if (self) {
        _defaultDownloadFolderIdentifier = defaultDownloadFolderIdentifier;
        _invisible = isInvisible;
        _subtitleLanguageCodes = subtitleLanguageCodes;
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithDefaultDownloadFolderIdentifier:NAN
                                   subtitleLanguageCodes:nil
                                             isInvisible:[NSNull null]];
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    NSArray *subtitleLanguageCodes = [dictionary objectForKey:@"subtitle_languages"];
    NSInteger defaultDownloadFolderIdentifier = [[dictionary objectForKey:@"default_download_folder"] integerValue];
    id invisible = [dictionary objectForKey:@"is_invisible"];
    
    if (subtitleLanguageCodes != nil &&
        !isnan(defaultDownloadFolderIdentifier) &&
        ![invisible isKindOfClass:NSNull.class])
    {
        return [self initWithDefaultDownloadFolderIdentifier:defaultDownloadFolderIdentifier
                                       subtitleLanguageCodes:subtitleLanguageCodes
                                                 isInvisible:[invisible boolValue]];
    }
    
    return nil;
}

- (instancetype)initWithDefaultDownloadFolderIdentifier:(NSInteger)defaultDownloadFolderIdentifier
                                  subtitleLanguageCodes:(NSArray<NSString *> *)subtitleLanguageCodes {
    return [self initWithDefaultDownloadFolderIdentifier:defaultDownloadFolderIdentifier
                                   subtitleLanguageCodes:subtitleLanguageCodes
                                             isInvisible:NULL];
}

- (instancetype)initWithIsInvisible:(BOOL)isInvisible {
    return [self initWithDefaultDownloadFolderIdentifier:NAN
                                   subtitleLanguageCodes:nil
                                             isInvisible:isInvisible];
}

- (instancetype)initWithSubtitleLanguageCodes:(NSArray<NSString *> *)subtitleLanguageCodes {
    return [self initWithDefaultDownloadFolderIdentifier:NAN
                                   subtitleLanguageCodes:subtitleLanguageCodes
                                             isInvisible:[NSNull null]];
}

- (instancetype)initWithDefaultDownloadFolderIdentifier:(NSInteger)defaultDownloadFolderIdentifier {
    return [self initWithDefaultDownloadFolderIdentifier:defaultDownloadFolderIdentifier
                                   subtitleLanguageCodes:nil
                                             isInvisible:[NSNull null]];
}

- (instancetype)initWithSubtitleLanguageCodes:(NSArray<NSString *> *)subtitleLanguageCodes
                                  isInvisible:(BOOL)isInvisible {
    return [self initWithDefaultDownloadFolderIdentifier:NAN
                                   subtitleLanguageCodes:subtitleLanguageCodes
                                             isInvisible:isInvisible];
}

- (instancetype)initWithDefaultDownloadFolderIdentifier:(NSInteger)defaultDownloadFolderIdentifier
                                            isInvisible:(BOOL)isInvisible {
    return [self initWithDefaultDownloadFolderIdentifier:defaultDownloadFolderIdentifier
                                   subtitleLanguageCodes:nil
                                             isInvisible:isInvisible];
}

- (NSString *)defaultSubtitleLanguageCode {
    return [_subtitleLanguageCodes firstObject];
}

@end

#pragma clang diagnostic pop
