//
//  PIOMP4Status.h
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

#import <Foundation/NSString.h>

/**
 The status of an MP4 file's conversion.
 */
typedef NSString *PIOMP4Status NS_EXTENSIBLE_STRING_ENUM NS_SWIFT_NAME(Mp4Status);

/** An MP4 has been requested and is currently awaiting conversion. */
extern PIOMP4Status const PIOMP4StatusInQueue;

/** Preparations are being made to enable the file to be converted. */
extern PIOMP4Status const PIOMP4StatusPreparing;

/** The MP4 is currently being converting. */
extern PIOMP4Status const PIOMP4StatusConverting;

/** The file has finished converting and @b Put.io is finalising and saving the file. */
extern PIOMP4Status const PIOMP4StatusFinishing;

/** The MP4 has finished converting and is now available. */
extern PIOMP4Status const PIOMP4StatusCompleted;

/** There is currently no MP4 available for the file. */
extern PIOMP4Status const PIOMP4StatusUnavailable;

/** The status of the file's conversion is unknown. */
extern PIOMP4Status const PIOMP4StatusUnknown;
