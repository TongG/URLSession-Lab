///:
/*****************************************************************************
 **                                                                         **
 **                               .======.                                  **
 **                               | INRI |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                      .========'      '========.                         **
 **                      |   _      xxxx      _   |                         **
 **                      |  /_;-.__ / _\  _.-;_\  |                         **
 **                      |     `-._`'`_/'`.-'     |                         **
 **                      '========.`\   /`========'                         **
 **                               | |  / |                                  **
 **                               |/-.(  |                                  **
 **                               |\_._\ |                                  **
 **                               | \ \`;|                                  **
 **                               |  > |/|                                  **
 **                               | / // |                                  **
 **                               | |//  |                                  **
 **                               | \(\  |                                  **
 **                               |  ``  |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                   \\    _  _\\| \//  |//_   _ \// _                     **
 **                  ^ `^`^ ^`` `^ ^` ``^^`  `^^` `^ `^                     **
 **                                                                         **
 **                       Copyright (c) 2015 Tong G.                        **
 **                          ALL RIGHTS RESERVED.                           **
 **                                                                         **
 ****************************************************************************/

#import <Cocoa/Cocoa.h>

// USLMainWindowController class
@interface USLMainWindowController : NSWindowController < NSURLSessionDelegate
                                                        , NSURLSessionTaskDelegate
                                                        , NSURLSessionDataDelegate
                                                        , NSURLSessionDownloadDelegate
                                                        >

@property ( unsafe_unretained ) IBOutlet NSTextField* URLField;
@property ( unsafe_unretained ) IBOutlet NSButton* goButton;

@property ( unsafe_unretained ) IBOutlet NSButton* requestTwitterToken;

@property ( retain ) NSURLSessionDataTask* dataTask;
@property ( retain ) NSURLSessionDownloadTask* downloadTask;

@property ( copy ) NSURLSession* backgroundSession;
@property ( copy ) NSURLSession* defaultSession;
@property ( copy ) NSURLSession* ephemeralSession;

@property ( retain ) NSMutableData* receivedData;

@property ( retain ) NSMutableDictionary* completionHandlerDictionary;

+ ( id ) mainWindowController;

#pragma mark Data Task
- ( IBAction ) goAction: ( id )_Sender;
- ( IBAction ) pauseAction: ( id )_Sender;
- ( IBAction ) resumeAction: ( id )_Sender;
- ( IBAction ) stopAction: ( id )_Sender;

#pragma mark Download Task
@property ( retain ) NSData* resumeData;

- ( IBAction ) downloadAction: ( id )_Sender;
- ( IBAction ) pauseDownloadAction: ( id )_Sender;
- ( IBAction ) resumeDownloadAction: ( id )_Sender;
- ( IBAction ) stopDownloadAction: ( id )_Sender;

@property ( unsafe_unretained ) IBOutlet NSTextField* signingKeyField;
@property ( unsafe_unretained ) IBOutlet NSTextField* PINField;
- ( IBAction ) signWithHMSCSHA1: ( id )_Sender;

@end // USLMainWindowController

//////////////////////////////////////////////////////////////////////////////

/*****************************************************************************
 **                                                                         **
 **      _________                                      _______             **
 **     |___   ___|                                   / ______ \            **
 **         | |     _______   _______   _______      | /      |_|           **
 **         | |    ||     || ||     || ||     ||     | |    _ __            **
 **         | |    ||     || ||     || ||     ||     | |   |__  \           **
 **         | |    ||     || ||     || ||     ||     | \_ _ __| |  _        **
 **         |_|    ||_____|| ||     || ||_____||      \________/  |_|       **
 **                                           ||                            **
 **                                    ||_____||                            **
 **                                                                         **
 ****************************************************************************/
///:~