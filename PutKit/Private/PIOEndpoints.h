//
//  PIOEndpoints.h
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

extern NSString * const kPIOEndpointAuthenticate;
extern NSString * const kPIOEndpointAccessToken;

extern NSString * const kPIOEndpointFiles;
extern NSString * const kPIOEndpointListFiles;
extern NSString * const kPIOEndpointSearchFiles;
extern NSString * const kPIOEndpointUploadFiles;
extern NSString * const kPIOEndpointCreateFolder;
extern NSString * const kPIOEndpointDeleteFiles;
extern NSString * const kPIOEndpointRenameFile;
extern NSString * const kPIOEndpointMoveFile;
extern NSString * const kPIOEndpointShareFiles;
extern NSString * const kPIOEndpointSharedFiles;

extern NSString * const kPIOEndpointListEvents;
extern NSString * const kPIOEndpointDeleteEvents;

extern NSString * const kPIOEndpointTransfers;
extern NSString * const kPIOEndpointListTransfers;
extern NSString * const kPIOEndpointAddTransfer;
extern NSString * const kPIOEndpointRetryTransfer;
extern NSString * const kPIOEndpointCancelTransfer;
extern NSString * const kPIOEndpointCleanTransfers;

extern NSString * const kPIOEndpointFriends;
extern NSString * const kPIOEndpointListFriends;
extern NSString * const kPIOEndpointFriendRequests;

extern NSString * const kPIOEndpointAccountInfo;
extern NSString * const kPIOEndpointAccountSettings;
