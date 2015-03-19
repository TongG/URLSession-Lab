//
//  USLAppDelegate.h
//  URLSession Lab
//
//  Created by Tong G. on 3/19/15.
//  Copyright (c) 2015 Tong Guo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class USLMainWindowController;

typedef void ( ^USLCompletionHandlerType )();

@interface USLAppDelegate : NSObject < NSApplicationDelegate
                                     , NSURLSessionDelegate
                                     , NSURLSessionTaskDelegate
                                     , NSURLSessionDataDelegate
                                     , NSURLSessionDownloadDelegate
                                     >

@property ( retain ) USLMainWindowController* mainWindowController;

@property ( copy ) NSURLSession* backgroundSession;
@property ( copy ) NSURLSession* defaultSession;
@property ( copy ) NSURLSession* ephemeralSession;

@property ( retain ) NSMutableDictionary* completionHandlerDictionary;

#if 0
- ( void ) addCompletionHandler: ( USLCompletionHandlerType )_Handler forSession: ( NSString* )_SessionID;
- ( void ) callCompletionHandlerForSession: ( NSString* )_SessionID;
#endif
@end
