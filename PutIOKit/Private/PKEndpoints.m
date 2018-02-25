//
//  PKEndpoints.m
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

#import "PKEndpoints.h"

#define PK_ENDPOINT_BASE @"https://api.put.io/v2"
#define PK_ENDPOINT_UPLOAD_BASE @"https://upload.put.io/v2"

NSString * const kPKEndpointAuthenticate = PK_ENDPOINT_BASE @"/oauth2/authenticate";
NSString * const kPKEndpointAccessToken = PK_ENDPOINT_BASE @"/oauth2/access_token";

NSString * const kPKEndpointFiles = PK_ENDPOINT_BASE @"/files";
NSString * const kPKEndpointListFiles = PK_ENDPOINT_BASE @"/files/list";
NSString * const kPKEndpointSearchFiles = PK_ENDPOINT_BASE @"/files/search";
NSString * const kPKEndpointUploadFiles = PK_ENDPOINT_UPLOAD_BASE @"/files/upload";
NSString * const kPKEndpointCreateFolder = PK_ENDPOINT_BASE @"/files/create-folder";
NSString * const kPKEndpointDeleteFiles = PK_ENDPOINT_BASE @"/files/delete";
NSString * const kPKEndpointRenameFile = PK_ENDPOINT_BASE @"/files/rename";
NSString * const kPKEndpointMoveFile = PK_ENDPOINT_BASE @"/files/move";
NSString * const kPKEndpointShareFiles = PK_ENDPOINT_BASE @"/files/share";
NSString * const kPKEndpointSharedFiles = PK_ENDPOINT_BASE @"/files/shared";

NSString * const kPKEndpointListEvents = PK_ENDPOINT_BASE @"/events/list";
NSString * const kPKEndpointDeleteEvents = PK_ENDPOINT_BASE @"/events/delete";

NSString * const kPKEndpointTransfers = PK_ENDPOINT_BASE @"/transfers";
NSString * const kPKEndpointListTransfers = PK_ENDPOINT_BASE @"/transfers/list";
NSString * const kPKEndpointAddTransfer = PK_ENDPOINT_BASE @"/transfers/add";
NSString * const kPKEndpointRetryTransfer = PK_ENDPOINT_BASE @"/transfers/retry";
NSString * const kPKEndpointCancelTransfer = PK_ENDPOINT_BASE @"/transfers/cancel";
NSString * const kPKEndpointCleanTransfers = PK_ENDPOINT_BASE @"/transfers/clean";

NSString * const kPKEndpointFriends = PK_ENDPOINT_BASE @"/friends";
NSString * const kPKEndpointListFriends = PK_ENDPOINT_BASE @"/friends/list";
NSString * const kPKEndpointFriendRequests = PK_ENDPOINT_BASE @"/friends/waiting-requests";

NSString * const kPKEndpointAccountInfo = PK_ENDPOINT_BASE @"/account/info";
NSString * const kPKEndpointAccountSettings = PK_ENDPOINT_BASE @"/account/settings";
