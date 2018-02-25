//
//  PIOEndpoints.m
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

#import "PIOEndpoints.h"

#define PIO_ENDPOINT_BASE @"https://api.put.io/v2"
#define PIO_ENDPOINT_UPLOAD_BASE @"https://upload.put.io/v2"

NSString * const kPIOEndpointAuthenticate = PIO_ENDPOINT_BASE @"/oauth2/authenticate";
NSString * const kPIOEndpointAccessToken = PIO_ENDPOINT_BASE @"/oauth2/access_token";

NSString * const kPIOEndpointFiles = PIO_ENDPOINT_BASE @"/files";
NSString * const kPIOEndpointListFiles = PIO_ENDPOINT_BASE @"/files/list";
NSString * const kPIOEndpointSearchFiles = PIO_ENDPOINT_BASE @"/files/search";
NSString * const kPIOEndpointUploadFiles = PIO_ENDPOINT_UPLOAD_BASE @"/files/upload";
NSString * const kPIOEndpointCreateFolder = PIO_ENDPOINT_BASE @"/files/create-folder";
NSString * const kPIOEndpointDeleteFiles = PIO_ENDPOINT_BASE @"/files/delete";
NSString * const kPIOEndpointRenameFile = PIO_ENDPOINT_BASE @"/files/rename";
NSString * const kPIOEndpointMoveFile = PIO_ENDPOINT_BASE @"/files/move";
NSString * const kPIOEndpointShareFiles = PIO_ENDPOINT_BASE @"/files/share";
NSString * const kPIOEndpointSharedFiles = PIO_ENDPOINT_BASE @"/files/shared";

NSString * const kPIOEndpointListEvents = PIO_ENDPOINT_BASE @"/events/list";
NSString * const kPIOEndpointDeleteEvents = PIO_ENDPOINT_BASE @"/events/delete";

NSString * const kPIOEndpointTransfers = PIO_ENDPOINT_BASE @"/transfers";
NSString * const kPIOEndpointListTransfers = PIO_ENDPOINT_BASE @"/transfers/list";
NSString * const kPIOEndpointAddTransfer = PIO_ENDPOINT_BASE @"/transfers/add";
NSString * const kPIOEndpointRetryTransfer = PIO_ENDPOINT_BASE @"/transfers/retry";
NSString * const kPIOEndpointCancelTransfer = PIO_ENDPOINT_BASE @"/transfers/cancel";
NSString * const kPIOEndpointCleanTransfers = PIO_ENDPOINT_BASE @"/transfers/clean";

NSString * const kPIOEndpointFriends = PIO_ENDPOINT_BASE @"/friends";
NSString * const kPIOEndpointListFriends = PIO_ENDPOINT_BASE @"/friends/list";
NSString * const kPIOEndpointFriendRequests = PIO_ENDPOINT_BASE @"/friends/waiting-requests";

NSString * const kPIOEndpointAccountInfo = PIO_ENDPOINT_BASE @"/account/info";
NSString * const kPIOEndpointAccountSettings = PIO_ENDPOINT_BASE @"/account/settings";
