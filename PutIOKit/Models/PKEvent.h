//
//  PKEvent.h
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
#import "PKEventType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 An event object used to describe downloads and shares.
 */
NS_SWIFT_NAME(Event)
@interface PKEvent : NSObject

/** The event's type. */
@property (nonatomic, readonly) PKEventType type;

/** The name of the event. */
@property (strong, nonatomic, readonly) NSString *name;

/** The date on which this event was created. */
@property (strong, nonatomic, readonly) NSDate *dateOfCreation NS_SWIFT_NAME(createdOn);

/** If this event's type is `PKEventTypeFileShared`, this is the name of the person with whom the file was shared, otherwise it is `nil`. */
@property (strong, nonatomic, nullable, readonly) NSString *sharingUsername;

/** The unique identifier for the file that is associated with the current event. */
@property (nonatomic, readonly) NSInteger fileIdentifier;

/** The size of the file in bytes. */
@property (nonatomic, readonly) NSInteger size;

@end

NS_ASSUME_NONNULL_END
