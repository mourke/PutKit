//
//  PutKitTests.m
//  PutKitTests
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

#import <XCTest/XCTest.h>
#import <PutKit/PutKit.h>

@interface PutKitTests : XCTestCase

@end

@implementation PutKitTests

- (void)setUp {
    [super setUp];
    
}


- (void)testListFiles {
    XCTestExpectation *expectation = [self expectationWithDescription:@"List files"];
    
    [[PIOAPI listFilesInFolderWithID:0 callback:^(NSError * _Nullable error,
                                                  NSArray<PIOFile *> * _Nonnull files,
                                                  PIOFile * _Nullable parent) {
        XCTAssertNil(error, @"Failed to load files %@", error);
        NSLog(@"%@", files);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testSearchFiles {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Search files"];
    
    [[PIOAPI searchFilesWithQuery:@"22 Jump"
                           onPage:1
                         callback:^(NSError * _Nullable error,
                                    NSArray<PIOFile *> * _Nonnull files,
                                    NSURL * _Nullable nextPageURL) {
        XCTAssertNil(error, @"Failed to search files %@", error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testTransfer {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Start transfer"];
    
    [[PIOAPI addTransferWithURL:[NSURL URLWithString:@"magnet:?xt=urn:btih:03BB57EA1F7E8DC9CC7DA349B549D7A7C5BC3359&amp;tr=udp://glotorrents.pw:6969/announce&amp;tr=udp://tracker.opentrackr.org:1337/announce&amp;tr=udp://torrent.gresille.org:80/announce&amp;tr=udp://tracker.openbittorrent.com:80&amp;tr=udp://tracker.coppersurfer.tk:6969&amp;tr=udp://tracker.leechers-paradise.org:6969&amp;tr=udp://p4p.arenabg.ch:1337&amp;tr=udp://tracker.internetwarriors.net:1337"]
           saveFolderIdentifier:0
                    callbackURL:nil
                  errorCallback:^(NSError * _Nullable error) {
                      XCTAssertNil(error, @"Failed to start transfer %@", error);
                      [expectation fulfill];
                  } progressCallback:^(NSError * _Nullable error, PIOTransfer * _Nullable transfer) {
                      NSLog(@"%@", transfer);
                  } completionCallback:^(PIOTransfer *transfer) {
                      NSLog(@"%@", transfer);
                      [expectation fulfill];
                  }] resume];
    
    
    [self waitForExpectationsWithTimeout:1000 handler:nil];
}

- (void)testHLS {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get HSL link from file id"];
    
    [[PIOAPI getFileForID:588577196 callback:^(NSError * _Nullable error, PIOFile * _Nullable file) {
        if (file.isFolder) {
            [[PIOAPI listFilesInFolderWithID:file.identifier callback:^(NSError * _Nullable error, NSArray<PIOFile *> * _Nonnull files, PIOFile * _Nullable folder) {
                
                for (PIOFile *file in files) {
                    if ([file.contentType containsString:@"video"]) {
                        NSURL *hslURL = [PIOAPI HLSURLForFileWithID:file.identifier subtitleID:@"all"];
                        XCTAssertNotNil(hslURL, @"Failed to create URL");
                        [expectation fulfill];
                    }
                }
            }] resume];
        } else {
            NSURL *hslURL = [PIOAPI HLSURLForFileWithID:file.identifier subtitleID:@"all"];
            XCTAssertNotNil(hslURL, @"Failed to create URL");
            [expectation fulfill];
        }
    }] resume];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}



@end
