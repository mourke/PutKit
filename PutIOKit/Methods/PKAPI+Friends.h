//
//  PKAPI+Friends.h
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
#import "PKErrorOnlyCallback.h"

@class PKFriend;

NS_ASSUME_NONNULL_BEGIN

@interface PKAPI (Friends)

/**
 Lists friends.
 
 @param callback    The block that is called when the request completes. If the request completes successfully, an array of `PKFriend` objects will be returned. However, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)listFriendsWithCallback:(void (^)(NSError * _Nullable, NSArray<PKFriend *> *))callback NS_SWIFT_NAME(listFriends(_:));

/**
 Lists incoming friend requests.
 
 @param callback    The block that is called when the request completes. If the request completes successfully, an array of `PKFriend` objects will be returned. However, if it fails, the underlying error will be returned.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)getFriendRequestsWithCallback:(void (^)(NSError * _Nullable, NSArray<PKFriend *> *))callback NS_SWIFT_NAME(friendRequests(_:));

/**
 Sends a friend request to the given username.
 
 @param username    The friend's username.
 @param callback    The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)sendFriendRequestToFriendNamed:(NSString *)username callback:(PKErrorOnlyCallback _Nullable)callback NS_SWIFT_NAME(sendFriendRequest(to:callback:));

/**
 Approves a friend request from the given username.
 
 @param username    The friend's username.
 @param callback    The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)approveFriendRequestFromFriendNamed:(NSString *)username callback:(PKErrorOnlyCallback _Nullable)callback NS_SWIFT_NAME(approveFriendRequest(from:callback:));

/**
 Denies a friend request from the given username.
 
 @param username    The friend's username.
 @param callback    The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)denyFriendRequestFromFriendNamed:(NSString *)username callback:(PKErrorOnlyCallback _Nullable)callback NS_SWIFT_NAME(denyFriendRequest(from:callback:));

/**
 Removes friend from friend list. Files shared with all friends will be automatically removed from old friend’s directory.
 
 @param username    The friend's username.
 @param callback    The block that is called when the request completes. If the request completes successfully the block will be called with a `nil` error passed in, however, if the request fails, the error will be passed in.
 
 @return    The request's `NSURLSessionDataTask` to be resumed.
 */
+ (NSURLSessionDataTask *)unfriendFriendRequestFromFriendNamed:(NSString *)username callback:(PKErrorOnlyCallback _Nullable)callback NS_SWIFT_NAME(unfriend(id:callback:));

@end

NS_ASSUME_NONNULL_END
