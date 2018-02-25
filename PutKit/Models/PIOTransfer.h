//
//  PIOTransfer.h
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
#import "PIOTransferStatus.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A transfer object. Transfers are associated with the transmission of a file to a user's computer.
 */
NS_SWIFT_NAME(Transfer)
@interface PIOTransfer : NSObject

/** The name of the file being transfered. */
@property (strong, nonatomic, readonly) NSString *name;

/** The unique identifier of the file being transferred. */
@property (nonatomic, readonly) NSInteger fileIdentifier;

/** The unique identifier for the folder in which the current file resides. 0 indicates the root directory. */
@property (nonatomic, readonly) NSInteger parentIdentifier;

/** The unique transfer id assigned by @b Put.io. */
@property (nonatomic, readonly) NSInteger identifier;

/** The source link (magnet or otherwise) of the file being transferred. */
@property (strong, nonatomic, nullable, readonly) NSString *source;

/** The identifier of the subsription by which the file download was instigated. May be NaN. */
@property (nonatomic, readonly) NSInteger subscriptionIdentifier;

/** The URL to which the transfer’s metadata is **POST**ed when the download has finished. */
@property (strong, nonatomic, nullable, readonly) NSURL *callbackURL NS_SWIFT_NAME(callbackUrl);

/** The date on which the transfer was created. */
@property (strong, nonatomic, readonly) NSDate *dateOfCreation NS_SWIFT_NAME(createdOn);

/** The date on which the transfer ended. */
@property (strong, nonatomic, readonly) NSDate *dateFinished NS_SWIFT_NAME(finishedOn);

/** The error object associated with this transfer. Will be `nil` until an error occurs. */
@property (strong, nonatomic, nullable, readonly) NSError *error;

/** A boolean value indicating whether the transfer is private or not. */
@property (nonatomic, readonly, getter=isPrivate) BOOL private;

/** The size of the file (in bytes). */
@property (nonatomic, readonly) NSInteger size;

/** The total amount of the file that has been uploaded (in bytes) since the transfer was started. */
@property (nonatomic, readonly) NSInteger totalUploaded;

/** The total amount of the file that has been downloaded (in bytes) since the transfer was started. */
@property (nonatomic, readonly) NSInteger totalDownloaded;

/** The percentage of the total file size that has been downloaded (in bytes). This can be manually calculated by dividing the `totalDownloaded` by the `size` and multiplying by 100. */
@property (nonatomic, readonly) double percentageDownloaded;

/** The estimated time (in seconds) the download will take to complete download. */
@property (nonatomic, readonly) NSTimeInterval estimatedTimeRemaining;

/** The speed of the download (in bytes per second). */
@property (nonatomic, readonly) double downloadSpeed;

/** The upload speed (in bytes per second). */
@property (nonatomic, readonly) double uploadSpeed;

/** The total number of peers connected to the transfer. */
@property (nonatomic, readonly) NSUInteger peers;

/** The number of peers fetching from @b Put.io. */
@property (nonatomic, readonly) NSUInteger peersLeaching;

/** The number of peers uploading to @b Put.io. */
@property (nonatomic, readonly) NSUInteger peersGiving;

/** The ratio of seeders to peers for the current transfer. */
@property (nonatomic, readonly) float seedToPeerRatio;

/** The status of transfer. */
@property (nonatomic, readonly) PIOTransferStatus status;

/** The status message of transfer containing an unlocalised concatination of the download speed, the number of peers and seeds connected, and the amount of the file that has been uploaded and downloaded. */
@property (strong, nonatomic, readonly) NSString *statusMessage;

/** A boolean value that, if enabled, causes the automatic extraction of the file after the download finishes. */
@property (nonatomic, readonly) BOOL willExtract;

/** The seeding status of the transfer. */
@property (nonatomic, readonly, getter=isSeeding) BOOL seeding;

/** The time (in seconds) for which the transfer has been seeding. */
@property (nonatomic, readonly) NSTimeInterval timeSeeding;

/** The tracker message of the transfer, if any. */
@property (nonatomic, nullable, readonly) NSString *trackerMessage;

@end

NS_ASSUME_NONNULL_END
