//
//  PutKit.h
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

#import <UIKit/UIKit.h>

//! Project version number for PutKit.
FOUNDATION_EXPORT double PutKitVersionNumber;

//! Project version string for PutKit.
FOUNDATION_EXPORT const unsigned char PutKitVersionString[];


// In this header, you should import all the public headers of your framework using statements like #import <PutKit/PublicHeader.h>

#pragma mark - Models

#import <PutKit/PIOErrorOnlyCallback.h>
#import <PutKit/PIOFile.h>
#import <PutKit/PIOShare.h>
#import <PutKit/PIOShareRecipient.h>
#import <PutKit/PIOSubtitle.h>
#import <PutKit/PIOSubtitleFormat.h>
#import <PutKit/PIOEventType.h>
#import <PutKit/PIOEvent.h>
#import <PutKit/PIOMP4Status.h>
#import <PutKit/PIOMP4Conversion.h>
#import <PutKit/PIOTransferStatus.h>
#import <PutKit/PIOTransfer.h>
#import <PutKit/PIOFriend.h>
#import <PutKit/PIOAccount.h>
#import <PutKit/PIOAccountSettings.h>

#pragma mark - Methods

#import <PutKit/PIOAPI.h>
#import <PutKit/PIOAPI+Files.h>
#import <PutKit/PIOAPI+Transfers.h>
#import <PutKit/PIOAPI+Friends.h>
#import <PutKit/PIOAPI+Account.h>

#pragma mark - Authentication

#import <PutKit/PIOAuthenticatorDelegate.h>
#import <PutKit/PIOAuth.h>
#import <PutKit/AFOAuthCredential.h>
