//
//  PKAPI+Files.h
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
#import "PKAPI.h"
#import "PKSubtitleFormat.h"
#import "PKErrorOnlyCallback.h"

@class PKFile, PKTransfer, PKMP4Conversion, PKShare, PKShareRecipient, PKSubtitle, PKEvent;

NS_ASSUME_NONNULL_BEGIN

@interface PKAPI (Files)


/**
 Lists all the files in a specified folder.
 
 @param folderIdentifier    The ID of the folder whose contents is to be listed. The root directory has an identifier of @b 0.
 @param callback            The block that is called when the request completes. If the request completes successfully, the contents of the folder and the folder will be returned as an array of `PKFile` objects and a `PKFile` object. However, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)listFilesInFolderWithID:(NSInteger)folderIdentifier
                                         callback:(void (^)(NSError * _Nullable, NSArray<PKFile *> *, PKFile * _Nullable))callback NS_SWIFT_NAME(listFiles(in:callback:));

/**
 Searches your files and files that have been shared with you. Returns 50 results at a time. The url for next 50 results is returned in the callback block.
 
 There is a special search syntax that can be deployed if more control is needed to filter results. There are three search keywords that can help filter a search's results: @b from, @b type, @b ext.
 
 from:  me, shares, jack or all
 type:  video, audio, image, iphone or all
 ext:   mp3, avi, jpg, mp4 or all
 
 Of course all of these are optional and a simple keyword search is acceptable too.
 
 @param query       The keyword to search. The search syntax must be appended after the query and each subsequent syntax must be separated from the previous by a space. E.g. 'https://put.io/v2/files/search/jazz from:”me,jack” ext:mp3' and 'https://put.io/v2/files/search/”jazz album” from:”shares”'.
 @param page        The page of results to fetch
 @param callback    The block that is called when the request completes. If the request completes successfully, an array of `PKFile` objects and an `NSURL` object indicating the next page of search results, if there is a next page. However, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)searchFilesWithQuery:(NSString *)query
                                        onPage:(NSInteger)page
                                      callback:(void (^)(NSError * _Nullable, NSArray<PKFile *> *, NSURL * _Nullable))callback NS_SWIFT_NAME(searchFiles(query:page:callback:));

/**
 Uploads a file to @b Put.io. This must @b not be a `.torrent` file otherwise an exception will be raised. The method `uploadTorrentFileAtURL:toFolderWithID:newFileName:callback:` must be used to upload torrents.
 
 @param fileURL             A url pointing to a valid file on the current device.
 @param parentIdentifier    The identifier of the folder to which the file should be uploaded.
 @param fileName            The name to change the file to when it has been successfully uploaded to @b Put.io. It is not necessary to change the name. If `nil` is passed in, the original file name will be kept.
 @param callback            The block that is called when the request completes. If the request completes successfully, the `PKFile` object, as it exists on the server, will be returned. However, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionUploadTask` to be resumed.
 */
+ (NSURLSessionUploadTask *)uploadFileAtURL:(NSURL *)fileURL
                             toFolderWithID:(NSInteger)parentIdentifier
                                newFileName:(NSString * _Nullable)fileName
                                   callback:(void (^ _Nullable)(NSError * _Nullable, PKFile * _Nullable))callback NS_SWIFT_NAME(upload(file:toFolder:newName:callback:));

/**
 Uploads a torrent file to @b Put.io. This @b must be a `.torrent` file otherwise an exception will be raised. The method `uploadFileAtURL:toFolderWithID:newFileName:callback:` must be used to upload regular files. If the upload completes successfully, a transfer will automatically be started.
 
 @param torrentURL          A url pointing to a valid torrent file on the current device.
 @param parentIdentifier    The identifier of the folder to which the torrent file should be uploaded.
 @param fileName            The name to change the torrent file to when it has been successfully uploaded to @b Put.io. It is not necessary to change the name. If `nil` is passed in, the original file name will be kept.
 @param callback            The block that is called when the request completes. If the request completes successfully, the `PKTransfer` object associated with the torrent transfer will be returned. However, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionUploadTask` to be resumed.
 */
+ (NSURLSessionUploadTask *)uploadTorrentFileAtURL:(NSURL *)torrentURL
                                    toFolderWithID:(NSInteger)parentIdentifier
                                       newFileName:(NSString * _Nullable)fileName
                                          callback:(void (^ _Nullable)(NSError * _Nullable, PKTransfer * _Nullable))callback NS_SWIFT_NAME(upload(torrent:toFolder:newName:callback:));

/**
 Creates a new folder with a specified name.
 
 @param folderName          The name of the folder to be created.
 @param parentIdentifier    The identifier of the folder to which the folder should be placed.
 @param callback            The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)createFolderNamed:(NSString *)folderName
                          inDirectoryWithID:(NSInteger)parentIdentifier
                                   callback:(PKErrorOnlyCallback _Nullable)callback NS_SWIFT_NAME(createFolder(named:in:callback:));

/**
 Returns a file’s properties.
 
 @param fileIdentifier  The identifier of the file whose properties are to be fetched.
 @param callback        The block that is called when the request completes. If the request completes successfully, the the `PKFile` will be returned, however, if it fails, block will be called with a `nil` error passed in, however, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)getFileForID:(NSInteger)fileIdentifier callback:(void (^)(NSError * _Nullable, PKFile * _Nullable))callback NS_SWIFT_NAME(file(for:callback:));

/**
 Deletes given files.
 
 @param fileIdentifiers An array of file identifiers to be deleted.
 @param callback        The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)deleteFilesWithIDs:(NSArray<NSNumber *> *)fileIdentifiers
                                    callback:(PKErrorOnlyCallback _Nullable)callback NS_SWIFT_NAME(delete(files:callback:));

/**
 Changes the name of a given file.
 
 @param fileIdentifier  The identifier of the file to be renamed.
 @param newName         The new name of the file
 @param callback        The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)renameFileWithID:(NSInteger)fileIdentifier
                                    toName:(NSString *)newName
                                  callback:(PKErrorOnlyCallback _Nullable)callback NS_SWIFT_NAME(rename(file:to:callback:));

/**
 Moves files to a given destination.
 
 @param fileIdentifiers         The identifiers of the files to be moved.
 @param destinationIdentifier   The identifier of the folder to which the files should be moved.
 @param callback                The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)moveFilesWithIDs:(NSArray<NSNumber *> *)fileIdentifiers
                            toFolderWithID:(NSInteger)destinationIdentifier
                                  callback:(PKErrorOnlyCallback _Nullable)callback NS_SWIFT_NAME(move(files:to:callback:));

/**
 Starts the conversion of a given file to MP4.
 
 @param fileIdentifier  The identifier of the file to be converted.
 @param callback        The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)beginConvertingFileWithIDToMP4:(NSInteger)fileIdentifier
                                                callback:(PKErrorOnlyCallback _Nullable)callback NS_SWIFT_NAME(beginConvertingToMp4(file:callback:));

/**
 Returns the status of the MP4 conversion of a given file.
 
 @param fileIdentifier  The identifier of the file being converted.
 @param callback        The block that is called when the request completes. If the request completes successfully, the `PKMP4Conversion` object associated with file conversion will be returned. However, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)getMP4ConversionStatusForFileWithID:(NSInteger)fileIdentifier
                                                     callback:(void (^)(NSError * _Nullable, PKMP4Conversion * _Nullable))callback NS_SWIFT_NAME(mp4ConversionStatus(for:callback:));

/**
 Downloads a given file.
 
 @param fileIdentifier  The identifier of the file to be downloaded.
 @param callback        The block that is called when the request completes. If the request completes successfully, the local file `NSURL` will be returned. This file will have been moved to the `NSDownloadsDirectory`. However, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDownloadTask` to be resumed. The request's `NSURLSessionDownloadTask` to be resumed. More information about the download (such as download status etc.) can be obtained using the delegate of the returned object.
 */
+ (NSURLSessionDownloadTask *)downloadFileForID:(NSInteger)fileIdentifier callback:(void (^)(NSError * _Nullable, NSURL * _Nullable))callback NS_SWIFT_NAME(download(file:callback:));

/**
 Shares given files with specified friends.
 
 @param fileIdentifiers The identifiers of the files to be shared.
 @param friends         The identifiers of the friends with whom to share the files. Passing @b -1 will share to everyone.
 @param callback        The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)shareFilesWithIDs:(NSArray<NSNumber *> *)fileIdentifiers
                           withFriendsNamed:(NSArray<NSString *> *)friends
                                   callback:(PKErrorOnlyCallback _Nullable)callback NS_SWIFT_NAME(share(files:with:callback:));

/**
 Returns list of shared files and share information.
 
 @param callback    The block that is called when the request completes. If the request completes successfully, an array of `PKShare` objects will be returned. However, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)listSharesWithCallback:(void (^)(NSError * _Nullable, NSArray<PKShare *> *))callback NS_SWIFT_NAME(listShares(_:));

/**
 Returns a list of users with whom the file is shared. Each result item contains a share identifier which can be used for unsharing.
 
 @param fileIdentifier  The identifier of the file for which share recipients are to be fetched.
 @param callback        The block that is called when the request completes. If the request completes successfully, an array of `PKShareRecipient` objects will be returned. However, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)listShareRecipientsForFileWithID:(NSInteger)fileIdentifier callback:(void (^)(NSError * _Nullable, NSArray<PKShareRecipient *> *))callback NS_SWIFT_NAME(shareRecipients(for:callback:));

/**
 Stops sharing a file with friends.
 
 @param fileIdentifier      The identifier of the file to stop sharing.
 @param shareIdentifiers    The identifiers of the people with whom to stop sharing the file. Passing @b -1 will stop sharing the file with everyone.
 @param callback            The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)stopSharingFileWithID:(NSInteger)fileIdentifier
                     withShareRecipientsWithIDs:(NSArray<NSNumber *> *)shareIdentifiers
                                       callback:(PKErrorOnlyCallback _Nullable)callback NS_SWIFT_NAME(stopSharing(file:with:callback:));

/**
 Lists available subtitles for user’s preferred language. User must select a “Default Subtitle Language” from the settings page.
 
 @param fileIdentifier  The identifier of the file for which subtitles are to be fetched.
 @param callback        The block that is called when the request completes. If the request completes successfully, an array of `PKShareRecipient` objects will be returned. However, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)listSubtitlesForFileWithID:(NSInteger)fileIdentifier callback:(void (^)(NSError * _Nullable, NSArray<PKSubtitle *> *))callback NS_SWIFT_NAME(subtitles(for:callback:));

/**
 Downloads a subtitle with a specified identifier. If no `subtitleIdentifier` is passed in, a subtitle will be automatically selected using the following search order:
 
    1. A subtitle file that has identical parent folder and name with the video.
    2. A subtitle file extracted from video if the format is `.mkv`.
    3. The first match from opensubtitles.
 
 @param subtitleIdentifier  The identifier of the subtitle obtained by calling `listSubtitlesForFileWithID:callback:`. If `nil` is passed in, a subtitle will be automatically selected by @b Put.io as described above.
 @param format              The format that the returned subtitle should be in.
 @param fileIdentifier      The identifier of the file for which subtitles are to be fetched.
 @param callback            The block that is called when the request completes. If the request completes successfully, the local file `NSURL` will be returned. This file will have been moved to the `NSDownloadsDirectory`. However, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDownloadTask` to be resumed. More information about the download (such as download status etc.) can be obtained using the delegate of the returned object.
 */
+ (NSURLSessionDownloadTask *)downloadSubtitleWithID:(NSString * _Nullable)subtitleIdentifier
                                          withFormat:(PKSubtitleFormat)format
                                       forFileWithID:(NSInteger)fileIdentifier callback:(void (^)(NSError * _Nullable, NSURL * _Nullable))callback NS_SWIFT_NAME(download(subtitle:format:forFile:callback:));

/**
 Returns the HTTP Live Streaming (HLS) `.m3u8` `NSURL` which can be directly passed into `AVPlayer` and played.
 
 @param fileIdentifier      The identifier of the video for which a HTTP Live Stream is to be created.
 @param subtitleIdentifier  The identifier of the subtitle, if any, to be embedded in the HTTP Live Stream.
 
 @return    The `NSURL` pointing to the `.m3u8` stream.
 */
+ (NSURL *)HLSURLForFileWithID:(NSInteger)fileIdentifier subtitleID:(NSString * _Nullable)subtitleIdentifier NS_SWIFT_NAME(hlsURL(for:subtitle:));

/**
 Lists a dashboard of events. This includes download and share events.
 
 @param callback    The block that is called when the request completes. If the request completes successfully, an array of `PKEvent` objects will be returned. However, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)listEventsWithCallback:(void (^)(NSError * _Nullable, NSArray<PKEvent *> *))callback NS_SWIFT_NAME(events(_:));

/**
 Clears all dashboard events.
 
 @param callback The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)deleteAllEventsWithCallback:(PKErrorOnlyCallback _Nullable)callback NS_SWIFT_NAME(deleteAllEvents(_:));

/**
 Sets the position at which the video will start when accessed through the `HLSURLForFileWithID:subtitleID:` method.
 
 @param startPosition   The position past the start point (in seconds) that the video should start when played.
 @param fileIdentifier  The identifier of the video file whose start position is to be changed.
 @param callback        The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)setStartPosition:(NSTimeInterval)startPosition
                             forFileWithID:(NSInteger)fileIdentifier
                                  callback:(PKErrorOnlyCallback _Nullable)callback NS_SWIFT_NAME(set(startPosition:for:callback:));

/**
 Removes the previously set position at which the video would have started when accessed through the `HLSURLForFileWithID:subtitleID:` method.
 
 @param fileIdentifier  The identifier of the video file whose start position is to be reset.
 @param callback        The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)removeStartPositionFromFileWithID:(NSInteger)fileIdentifier
                                  callback:(PKErrorOnlyCallback _Nullable)callback NS_SWIFT_NAME(removeStartPosition(from:callback:));

@end

NS_ASSUME_NONNULL_END
