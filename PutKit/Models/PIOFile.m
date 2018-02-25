//
//  PIOFile.m
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

#import "PIOFile.h"
#import "PIOObjectProtocol.h"

@interface PIOFile() <PIOObjectProtocol>

@end

@implementation PIOFile

- (nullable instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _contentType = [[dictionary objectForKey:@"content_type"] stringValue];
        _iconURL = [NSURL URLWithString:[[dictionary objectForKey:@"icon"] stringValue]];
        _identifier = [[dictionary objectForKey:@"id"] integerValue];
        _name = [[dictionary objectForKey:@"name"] stringValue];
        _parentIdentifier = [[dictionary objectForKey:@"parent_id"] integerValue];
        _size = [[dictionary objectForKey:@"size"] integerValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        _dateOfCreation = [dateFormatter dateFromString:[[dictionary objectForKey:@"created_at"] stringValue]];
        
        if (!isnan(_identifier) &&
            _contentType != nil &&
            _iconURL != nil &&
            !isnan(_identifier) &&
            _name != nil &&
            !isnan(_parentIdentifier) &&
            !isnan(_size) &&
            _dateOfCreation != nil)
        {
            _cyclicRedundancyCode = [[dictionary objectForKey:@"crc32"] stringValue];
            _dateFirstAccessed = [dateFormatter dateFromString:[[dictionary objectForKey:@"first_accessed_at"] stringValue]];
            _MP4Available = [[dictionary objectForKey:@"is_mp4_available"] boolValue];
            _shared = [[dictionary objectForKey:@"is_shared"] boolValue];
            _openSubtitlesHash = [[dictionary objectForKey:@"opensubtitles_hash"] stringValue];
            _screenshotURL = [NSURL URLWithString:[[dictionary objectForKey:@"screenshot"] stringValue]];
            
            return self;
        }
    }
    
    return nil;
}

@end
