//
//  PIOEvent.m
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

#import "PIOEvent.h"
#import "PIOObjectProtocol.h"

@interface PIOEvent() <PIOObjectProtocol>

@end

@implementation PIOEvent

- (nullable instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _type = [dictionary objectForKey:@"type"];
        
        if (_type == nil) return nil;
        
        if ([_type isEqualToString:PIOEventTypeFileShared] || [_type isEqualToString:PIOEventTypeZipCreated]) {
            _name = [dictionary objectForKey:@"file_name"];
            _size = [[dictionary objectForKey:@"file_size"] integerValue];
        } else {
            _name = [dictionary objectForKey:@"transfer_name"];
            _size = [[dictionary objectForKey:@"transfer_size"] unsignedIntegerValue];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        _dateOfCreation = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];
        
        if (_name != nil &&
            !isnan(_size) &&
            _dateOfCreation != nil)
        {
            NSString *sharingUsername = [dictionary objectForKey:@"sharing_user_name"];
            if ([sharingUsername isKindOfClass:NSString.class]) _sharingUsername = sharingUsername;
            
            return self;
        }
    }
    
    return nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> type = %@; name = %@; dateOfCreation = %@; sharingUsername = %@; fileIdentifier = %zd; size = %tu", [self class], self, self.type, self.name, self.dateOfCreation, self.sharingUsername, self.fileIdentifier, self.size];
}

@end
