//
//  PutIOKit.h
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

#import <UIKit/UIKit.h>

//! Project version number for PutIOKit.
FOUNDATION_EXPORT double PutIOKitVersionNumber;

//! Project version string for PutIOKit.
FOUNDATION_EXPORT const unsigned char PutIOKitVersionString[];


// In this header, you should import all the public headers of your framework using statements like #import <PutIOKit/PublicHeader.h>

#pragma mark - Models

#import <PutIOKit/PKErrorOnlyCallback.h>
#import <PutIOKit/PKFile.h>
#import <PutIOKit/PKShare.h>
#import <PutIOKit/PKShareRecipient.h>
#import <PutIOKit/PKSubtitle.h>
#import <PutIOKit/PKSubtitleFormat.h>
#import <PutIOKit/PKEventType.h>
#import <PutIOKit/PKEvent.h>
#import <PutIOKit/PKMP4Status.h>
#import <PutIOKit/PKMP4Conversion.h>
#import <PutIOKit/PKTransferStatus.h>
#import <PutIOKit/PKTransfer.h>
#import <PutIOKit/PKFriend.h>
#import <PutIOKit/PKAccount.h>
#import <PutIOKit/PKAccountSettings.h>

#pragma mark - Methods

#import <PutIOKit/PKAPI.h>
#import <PutIOKit/PKAPI+Files.h>
#import <PutIOKit/PKAPI+Transfers.h>
#import <PutIOKit/PKAPI+Friends.h>
#import <PutIOKit/PKAPI+Account.h>

#pragma mark - Authentication

#import <PutIOKit/PKAuthenticatorDelegate.h>
#import <PutIOKit/PKAuth.h>
#import <PutIOKit/AFOAuthCredential.h>
