//
//  PIOFile.h
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

NS_ASSUME_NONNULL_BEGIN

/**
 A file object.
 
 @important `File` objects are not always file types - they can be folders too. In order to check, there is a `contentType` variable on this object which will uncover exactly what type of file this is.
 */
NS_SWIFT_NAME(File)
@interface PIOFile : NSObject

/** The name of the file. */
@property (strong, nonatomic, readonly) NSString *name;

/** The MIME type for the file. */
@property (strong, nonatomic, readonly) NSString *contentType;

/** The unique identifier for the file. */
@property (nonatomic, readonly) NSInteger identifier;

/** The unique identifier for the folder in which the current file resides. 0 indicates the root directory. */
@property (nonatomic, readonly) NSInteger parentIdentifier;

/** The CRC32 checksum for the file, used to verify data integrity. */
@property (strong, nonatomic, nullable, readonly) NSString *cyclicRedundancyCode;

/** The date on which the file was created. */
@property (strong, nonatomic, readonly) NSDate *dateOfCreation NS_SWIFT_NAME(createdOn);

/** The date on which the file was first accessed. */
@property (strong, nonatomic, readonly) NSDate *dateFirstAccessed NS_SWIFT_NAME(firstAccessedOn);

/** The URL for the file's icon. */
@property (strong, nonatomic, readonly) NSURL *iconURL NS_SWIFT_NAME(icon);

/** The URL for the file's screenshot, if any. */
@property (strong, nonatomic, nullable, readonly) NSURL *screenshotURL NS_SWIFT_NAME(screenshot);

/** A boolean value indicating whether or not MP4 conversion is available. */
@property (nonatomic, readonly, getter=isMP4Available) BOOL MP4Available NS_SWIFT_NAME(mp4Available);

/** A boolean value indicating whether or not the file is shared. */
@property (nonatomic, readonly, getter=isShared) BOOL shared;

/** The hash string for the file's corresponding subtitle, if any. */
@property (strong, nonatomic, nullable, readonly) NSString *openSubtitlesHash;

/** The size of the file in bytes. */
@property (nonatomic, readonly) NSUInteger size;

/** A boolean value indicating whether or not the file is actually a folder. */
@property (nonatomic, readonly, getter=isFolder) BOOL folder;

@end

NS_ASSUME_NONNULL_END
