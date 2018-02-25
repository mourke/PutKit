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

#import <PutIOKit/PIOErrorOnlyCallback.h>
#import <PutIOKit/PIOFile.h>
#import <PutIOKit/PIOShare.h>
#import <PutIOKit/PIOShareRecipient.h>
#import <PutIOKit/PIOSubtitle.h>
#import <PutIOKit/PIOSubtitleFormat.h>
#import <PutIOKit/PIOEventType.h>
#import <PutIOKit/PIOEvent.h>
#import <PutIOKit/PIOMP4Status.h>
#import <PutIOKit/PIOMP4Conversion.h>
#import <PutIOKit/PIOTransferStatus.h>
#import <PutIOKit/PIOTransfer.h>
#import <PutIOKit/PIOFriend.h>
#import <PutIOKit/PIOAccount.h>
#import <PutIOKit/PIOAccountSettings.h>

#pragma mark - Methods

#import <PutIOKit/PIOAPI.h>
#import <PutIOKit/PIOAPI+Files.h>
#import <PutIOKit/PIOAPI+Transfers.h>
#import <PutIOKit/PIOAPI+Friends.h>
#import <PutIOKit/PIOAPI+Account.h>

#pragma mark - Authentication

#import <PutIOKit/PIOAuthenticatorDelegate.h>
#import <PutIOKit/PIOAuth.h>
#import <PutIOKit/AFOAuthCredential.h>
