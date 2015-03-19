//
//  USLAppDelegate.m
//  URLSession Lab
//
//  Created by Tong G. on 3/19/15.
//  Copyright (c) 2015 Tong Guo. All rights reserved.
//

#import "USLAppDelegate.h"

@implementation USLAppDelegate

- ( void ) applicationDidFinishLaunching: ( NSNotification* )_Notification
    {
    NSURLSession* defaultSession =
        [ NSURLSession sessionWithConfiguration: [ NSURLSessionConfiguration defaultSessionConfiguration ] ];

    NSURL* hotTopicsAPI = [ NSURL URLWithString: @"https://www.v2ex.com/api/topics/hot.json" ];
    NSURLSessionDataTask* hotTopics = [ defaultSession dataTaskWithURL: hotTopicsAPI
                                                     completionHandler:
        ^( NSData* _Data, NSURLResponse* _Response, NSError* _Error )
            {
            NSError* error = nil;

            NSMutableArray* responseBody =
                [ NSJSONSerialization JSONObjectWithData: _Data options: NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error: &error ];

            if ( !error )
                NSLog( @"Hot Topics: %@", responseBody );
            else
                [ self.window presentError: error ];

            NSLog( @"Response: %@",_Response );

            if ( _Error )
                NSLog( @"Error: %@", _Error );
            } ];

    [ hotTopics resume ];
    NSLog( @"Count of bytes expected to receive: %lld", hotTopics.countOfBytesExpectedToReceive );
    }

@end
