//
//  PKShare.m
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

#import "PKShare.h"
#import "PKObjectProtocol.h"

@interface PKShare() <PKObjectProtocol>

@end

@implementation PKShare

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _fileIdentifier = [[dictionary objectForKey:@"id"] integerValue];
        _fileName = [[dictionary objectForKey:@"name"] stringValue];
        id sharedWith = [dictionary objectForKey:@"shared_with"];
        
        _numberOfPeopleSharedWith = [sharedWith stringValue] != nil ? -1 : [sharedWith integerValue];
        
        if (!isnan(_fileIdentifier) && _fileName != nil && !isnan(_numberOfPeopleSharedWith)) return self;
    }
    
    return nil;
}

@end
