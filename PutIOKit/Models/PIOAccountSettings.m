//
//  PIOAccountSettings.m
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

#import "PIOAccountSettings.h"
#import "PIOObjectProtocol.h"

@interface PIOAccountSettings() <PIOObjectProtocol>

@end

@implementation PIOAccountSettings

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        NSArray *subtitleLanguageCodes = [dictionary objectForKey:@"subtitle_languages"];
        NSString *defaultSubtitleLanguageCode = [[dictionary objectForKey:@"default_subtitle_language"] stringValue];
        NSInteger defaultDownloadFolderIdentifier = [[dictionary objectForKey:@"default_download_folder"] integerValue];
        
        if (subtitleLanguageCodes != nil &&
            defaultSubtitleLanguageCode != nil &&
            !isnan(defaultDownloadFolderIdentifier))
        {
            _invisible = [[dictionary objectForKey:@"is_invisible"] boolValue];
            _subtitleLanguageCodes = subtitleLanguageCodes;
            _defaultSubtitleLanguageCode = defaultSubtitleLanguageCode;
            _defaultDownloadFolderIdentifier = defaultDownloadFolderIdentifier;
            
            return self;
        }
    }
    
    return nil;
}

- (instancetype)initWithDefaultDownloadFolderIdentifier:(NSInteger)defaultDownloadFolderIdentifier
                                            isInvisible:(BOOL)isInvisible
                                  subtitleLanguageCodes:(NSArray<NSString *> *)subtitleLanguageCodes {
    NSParameterAssert(subtitleLanguageCodes.count <= 2);
    
    self = [super init];
    
    if (self) {
        _defaultDownloadFolderIdentifier = defaultDownloadFolderIdentifier;
        _invisible = isInvisible;
        _subtitleLanguageCodes = subtitleLanguageCodes;
    }
    
    return self;
}

@end
