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
    NSString* cachePath = [ NSTemporaryDirectory() stringByAppendingString: @"URLSessionLabCaches" ];
    NSURLCache* globalCache = [ [ [ NSURLCache alloc ] initWithMemoryCapacity: 20 * 1024
                                                                 diskCapacity: 10 * 1024 * 1024
                                                                     diskPath: cachePath ] autorelease ];
    [ NSURLCache setSharedURLCache: globalCache ];

    self.mainWindowController = [ USLMainWindowController mainWindowController ];
    }

- ( void ) applicationDidFinishLaunching: ( NSNotification* )_Notification
    {
    [ self.mainWindowController showWindow: self ];
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
