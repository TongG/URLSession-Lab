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
    NSURLCache* globalCache = nil;
#if !__has_feature( objc_arc )
    globalCache = [ [ [ NSURLCache alloc ] initWithMemoryCapacity: 20 * 1024
                                                     diskCapacity: 10 * 1024 * 1024
                                                         diskPath: cachePath ] autorelease ];
#else
    globalCache = [ [ NSURLCache alloc ] initWithMemoryCapacity: 20 * 1024
                                                   diskCapacity: 10 * 1024 * 1024
                                                       diskPath: cachePath ];
#endif
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
                #if !__has_feature( objc_arc )
                    self.preferencesWindowController =
                        [ [ [ MASPreferencesWindowController alloc ] initWithViewControllers: @[ [ [ [ USLCacheTabController alloc ] init ] autorelease ] ] ] autorelease ];
                #else
                    self.preferencesWindowController =
                        [ [ MASPreferencesWindowController alloc ] initWithViewControllers: @[ [ [ USLCacheTabController alloc ] init ] ] ];
                #endif
                    } );

    [ self.preferencesWindowController showWindow: self ];
    }

@end
