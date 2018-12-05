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
        _contentType = [dictionary objectForKey:@"content_type"];
        _iconURL = [NSURL URLWithString:[dictionary objectForKey:@"icon"]];
        _identifier = [[dictionary objectForKey:@"id"] integerValue];
        _name = [dictionary objectForKey:@"name"];
        _size = [[dictionary objectForKey:@"size"] integerValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        _dateOfCreation = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];
        
        if (!isnan(_identifier) &&
            _contentType != nil &&
            _iconURL != nil &&
            !isnan(_identifier) &&
            _name != nil &&
            !isnan(_size) &&
            _dateOfCreation != nil)
        {
            _MP4Available = [[dictionary objectForKey:@"is_mp4_available"] boolValue];
            _shared = [[dictionary objectForKey:@"is_shared"] boolValue];
            
            NSString *cyclicRedundancyCode = [dictionary objectForKey:@"crc32"];
            if ([cyclicRedundancyCode isKindOfClass:NSString.class]) _cyclicRedundancyCode = cyclicRedundancyCode;
            
            NSString *openSubtitlesHash = [dictionary objectForKey:@"opensubtitles_hash"];
            if ([openSubtitlesHash isKindOfClass:NSString.class]) _openSubtitlesHash = openSubtitlesHash;
            
            id parentIdentifier = [dictionary objectForKey:@"parent_id"];
            if (parentIdentifier != [NSNull null]) _parentIdentifier = [parentIdentifier integerValue];
            
            NSString *screenshotString = [dictionary objectForKey:@"screenshot"];
            if ([screenshotString isKindOfClass:NSString.class]) _screenshotURL = [NSURL URLWithString:screenshotString];
            
            NSString *dateFirstAccessedString = [dictionary objectForKey:@"first_accessed_at"];
            
            if ([dateFirstAccessedString isKindOfClass:NSString.class]) _dateFirstAccessed = [dateFormatter dateFromString: dateFirstAccessedString];
            
            return self;
        }
    }
    
    return nil;
}

- (BOOL)isFolder {
    return [self.contentType isEqualToString:@"application/x-directory"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> name = %@; contentType = %@; identifier = %zd; parentIdentifier = %zd; cyclicRedundancyCode = %@; dateOfCreation = %@; dateFirstAccessed = %@; iconURL = %@; screenshotURL = %@; isMP4Available = %@; isShared = %@; openSubtitlesHash = %@; size = %tu; isFolder = %@", [self class], self, self.name, self.contentType, self.identifier, self.parentIdentifier, self.cyclicRedundancyCode, self.dateOfCreation, self.dateFirstAccessed, self.iconURL, self.screenshotURL, self.isMP4Available ? @"YES" : @"NO", self.isShared ? @"YES" : @"NO", self.openSubtitlesHash, self.size, self.isFolder ? @"YES" : @"NO"];
}

@end
