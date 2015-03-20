//
//  USLAppDelegate.h
//  URLSession Lab
//
//  Created by Tong G. on 3/19/15.
//  Copyright (c) 2015 Tong Guo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MASPreferencesWindowController;
@class USLMainWindowController;

typedef void ( ^USLCompletionHandlerType )();

@interface USLAppDelegate : NSObject <NSApplicationDelegate>

@property ( retain ) USLMainWindowController* mainWindowController;
@property ( retain ) MASPreferencesWindowController* preferencesWindowController;

- ( IBAction ) showPreferencesPanel: ( id )_Sender;

#if 0
- ( void ) addCompletionHandler: ( USLCompletionHandlerType )_Handler forSession: ( NSString* )_SessionID;
- ( void ) callCompletionHandlerForSession: ( NSString* )_SessionID;
#endif
@end
