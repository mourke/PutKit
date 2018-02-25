//
//  PIOAccount.m
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

#import "PIOAccount.h"
#import "PIOObjectProtocol.h"

@interface PIOAccount() <PIOObjectProtocol>

@end

@implementation PIOAccount

- (nullable instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _username = [dictionary objectForKey:@"username"];
        _emailAddress = [dictionary objectForKey:@"mail"];
        _subtitleLanguageCodes = [dictionary objectForKey:@"subtitle_languages"];
        _defaultSubtitleLanguageCode = [dictionary objectForKey:@"default_subtitle_language"];
        
        NSDictionary *diskDictionary = [dictionary objectForKey:@"disk"];
        
        _diskSpaceAvailable = [[diskDictionary objectForKey:@"avail"] integerValue];
        _diskSpaceUsed = [[diskDictionary objectForKey:@"used"] integerValue];
        _totalDiskSize = [[diskDictionary objectForKey:@"size"] integerValue];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        NSString *planExpiryDateString = [dictionary objectForKey:@"plan_expiration_date"];
        
        if (_username != nil &&
            _emailAddress != nil &&
            _subtitleLanguageCodes != nil &&
            _defaultSubtitleLanguageCode != nil &&
            !isnan(_diskSpaceAvailable) &&
            !isnan(_diskSpaceUsed) &&
            !isnan(_totalDiskSize) &&
            planExpiryDateString != nil)
        {
            _planExpiryDate = [dateFormatter dateFromString:planExpiryDateString];
            
            return self;
        }
    }
    
    return nil;
}

@end
