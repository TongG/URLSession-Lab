//
//  URLSession_LabTests.m
//  URLSession LabTests
//
//  Created by Tong G. on 3/19/15.
//  Copyright (c) 2015 Tong Guo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AppKit/NSApplication.h>

#import "USLAppDelegate.h"

@interface URLSession_LabTests : XCTestCase

@end

@implementation URLSession_LabTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- ( void ) testDefaultSession
    {
    NSURLSession* defaultSession =
        [ NSURLSession sessionWithConfiguration: [ NSURLSessionConfiguration defaultSessionConfiguration ] ];

    NSURL* hotTopicsAPI = [ NSURL URLWithString: @"https://www.v2ex.com/api/topics/hot.json" ];
    NSURLSessionDataTask* hotTopicsTask = [ defaultSession dataTaskWithURL: hotTopicsAPI
                                                         completionHandler:
        ^( NSData* _Data, NSURLResponse* _Response, NSError* _Error )
            {
            NSError* error = nil;

            NSMutableArray* responseBody =
                [ NSJSONSerialization JSONObjectWithData: _Data options: NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error: &error ];

            if ( !error )
                NSLog( @"Hot Topics: %@", responseBody );

            NSLog( @"Response: %@",_Response );
            NSLog( @"Error: %@", _Error );
            } ];

    NSURLSession* sessionCopy0 = [ defaultSession copy ];
    NSURLSession* sessionCopy1 = [ defaultSession copy ];
    NSURLSession* sessionCopy2 = [ defaultSession copy ];
    NSURLSession* sessionCopy3 = [ defaultSession copy ];

    XCTAssertEqual( defaultSession, sessionCopy0 );
    XCTAssertEqual( sessionCopy1, sessionCopy2 );
    XCTAssertEqual( sessionCopy2, sessionCopy3 );
    XCTAssertEqual( sessionCopy3, defaultSession );

    NSURLSessionDataTask* hotTopicsTaskCopy0 = [ hotTopicsTask copy ];
    NSURLSessionDataTask* hotTopicsTaskCopy1 = [ hotTopicsTask copy ];
    NSURLSessionDataTask* hotTopicsTaskCopy2 = [ hotTopicsTask copy ];
    NSURLSessionDataTask* hotTopicsTaskCopy3 = [ hotTopicsTask copy ];

    XCTAssertEqual( hotTopicsTask, hotTopicsTaskCopy0 );
    XCTAssertEqual( hotTopicsTaskCopy0, hotTopicsTaskCopy1 );
    XCTAssertEqual( hotTopicsTaskCopy2, hotTopicsTaskCopy3 );
    XCTAssertEqual( hotTopicsTaskCopy3, hotTopicsTask );

    NSURLSessionConfiguration* configurationCopy0 = [ defaultSession configuration ];
    NSURLSessionConfiguration* configurationCopy1 = [ defaultSession configuration ];
    NSURLSessionConfiguration* configurationCopy2 = [ defaultSession configuration ];
    NSURLSessionConfiguration* configurationCopy3 = [ defaultSession configuration ];

    XCTAssertNotEqual( configurationCopy0, configurationCopy1 );
    XCTAssertNotEqual( configurationCopy1, configurationCopy2 );
    XCTAssertNotEqual( configurationCopy2, configurationCopy3 );
    XCTAssertNotEqual( configurationCopy3, configurationCopy0 );

    [ hotTopicsTask resume ];
    }

- ( void ) testBackgroundTransfer
    {
    NSURLSession* downloadSession = [ NSURLSession sessionWithConfiguration:
        [ NSURLSessionConfiguration backgroundSessionConfiguration: @"individual.TongGuo.URLSesson-Lab" ] ];

    NSURLSession* copy1 = [ downloadSession copy ];
    NSURLSession* copy2 = [ downloadSession copy ];
    }

@end
