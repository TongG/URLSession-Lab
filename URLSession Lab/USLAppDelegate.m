//
//  USLAppDelegate.m
//  URLSession Lab
//
//  Created by Tong G. on 3/19/15.
//  Copyright (c) 2015 Tong Guo. All rights reserved.
//

#import "USLAppDelegate.h"
#import "USLMainWindowController.h"
#import "MASPreferencesViewController.h"
#import "MASPreferencesWindowController.h"
#import "USLCacheTabController.h"

@implementation USLAppDelegate

@synthesize preferencesWindowController;

@synthesize mainWindowController = _mainWindowController;

- ( void ) awakeFromNib
    {
    NSLog( @"Before Setting: %@", [ NSURLCache sharedURLCache ] );

    NSString* cachePath = [ NSTemporaryDirectory() stringByAppendingString: @"URLSessionLabCaches" ];
    NSURLCache* globalCache = [ [ [ NSURLCache alloc ] initWithMemoryCapacity: 20 * 1024
                                                                 diskCapacity: 10 * 1024 * 1024
                                                                     diskPath: cachePath ] autorelease ];
    [ NSURLCache setSharedURLCache: globalCache ];

    NSLog( @"After Setting: %@", [ NSURLCache sharedURLCache ] );

    self.mainWindowController = [ USLMainWindowController mainWindowController ];
    }

- ( void ) applicationDidFinishLaunching: ( NSNotification* )_Notification
    {
    [ self.mainWindowController showWindow: self ];
#if 0
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
                [ self.mainWindowController.window presentError: error ];

            NSLog( @"Response: %@",_Response );

            if ( _Error )
                NSLog( @"Error: %@", _Error );
            } ];

    [ hotTopics resume ];
    NSLog( @"Count of bytes expected to receive: %lld", hotTopics.countOfBytesExpectedToReceive );
#endif
    }

- ( IBAction ) showPreferencesPanel: ( id )_Sender
    {
    dispatch_once_t static onceToken;
    dispatch_once( &onceToken
                 , ^( void )
                    {
                    self.preferencesWindowController =
                        [ [ [ MASPreferencesWindowController alloc ] initWithViewControllers: @[ [ [ [ USLCacheTabController alloc ] init ] autorelease ] ] ] autorelease ];
                    } );

    [ self.preferencesWindowController showWindow: self ];
    }

@end
