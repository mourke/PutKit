//
//  PKAPI+Transfers.h
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
#import "PKErrorOnlyCallback.h"
#import "PKAPI.h"

@class PKTransfer;

NS_ASSUME_NONNULL_BEGIN

@interface PKAPI (Transfers)

/**
 Lists active transfers. When the transfer completes, it gets removed from the list.
 
 @param callback    The block that is called when the request completes. If the request completes successfully, an array of `PKTransfer` objects will be returned. However, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)listActiveTransfersWithCallback:(void (^)(NSError * _Nullable, NSArray<PKTransfer *> *))callback NS_SWIFT_NAME(listTransfers(_:));

/**
 Starts a new transfer.
 
 @param URL                 The link (magnet, torrent, direct file URL etc.) to the transfer that is to be started.
 @param parentIdentifier    The identifier of the folder in which the completed transfer is to be saved.
 @param callbackURL         An optional URL to which transfer metadata will be posted once the transfer successfully completes.
 @param callback            The block that is called when the request completes. If the request completes successfully, the `PKTransfer` object will be returned. This object will have the initial metadata about the download. To get updated metadata, call the `getTransferForID:callback:` method, passing in the identifier recieved from this `PKTransfer` object. If the request fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)addTransferWithURL:(NSURL *)URL
                        saveFolderIdentifier:(NSInteger)parentIdentifier
                                 callbackURL:(NSURL * _Nullable)callbackURL
                                    callback:(void (^)(NSError * _Nullable, PKTransfer * _Nullable))callback NS_SWIFT_NAME(addTransfer(url:saveFolder:callbackURL:callback:));

/**
 Returns a transfer’s properties.
 
 @param transferIdentifier  The identifier of the transfer whose properties are to be returned.
 @param callback            The block that is called when the request completes. If the request completes successfully, the `PKTransfer` object will be returned. However, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)getTransferForID:(NSInteger)transferIdentifier callback:(void (^)(NSError * _Nullable, PKTransfer * _Nullable))callback NS_SWIFT_NAME(transfer(for:callback:));

/**
 Retries a previously failed transfer.
 
 @param transferIdentifier  The identifier of the transfer which is to be retried.
 @param callback            The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)retryTransferWithIdentifier:(NSInteger)transferIdentifier callback:(PKErrorOnlyCallback)callback;

/**
 Cancels and deletes the given transfers.
 
 @param transferIdentifiers The identifiers of the transfers which are to be deleted.
 @param callback            The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)cancelTransfersWithIdentifiers:(NSArray<NSNumber *> *)transferIdentifiers callback:(PKErrorOnlyCallback)callback;

/**
 Cleans completed transfers from the list.
 
 @param callback    The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)cleanCompletedTransfersWithCallback:(PKErrorOnlyCallback)callback;

@end

NS_ASSUME_NONNULL_END
