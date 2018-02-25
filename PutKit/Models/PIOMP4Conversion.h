//
//  PIOMP4Conversion.h
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
#import "PIOMP4Status.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A conversion object.
 */
NS_SWIFT_NAME(Mp4Conversion)
@interface PIOMP4Conversion : NSObject

/** The status of the conversion. */
@property (strong, nonatomic, readonly) PIOMP4Status status;

/** The percentage of the conversion that has so far completed. Will be `NaN` if `status` is either `PIOMP4StatusInQueue`, `PIOMP4StatusPreparing` or `PIOMP4StatusUnavailable`. */
@property (nonatomic, readonly) NSInteger percentageCompleted;

/** The size of the completed **.mp4** file. Will be `NaN` if `status` is anything other than `PIOMP4StatusCompleted`. */
@property (nonatomic, readonly) NSInteger size;

@end

NS_ASSUME_NONNULL_END
