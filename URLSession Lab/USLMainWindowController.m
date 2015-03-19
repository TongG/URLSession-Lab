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
 **                       Copyright (c) Tong G.                        **
 **                          ALL RIGHTS RESERVED.                           **
 **                                                                         **
 ****************************************************************************/

#import "USLMainWindowController.h"

// USLMainWindowController class
@implementation USLMainWindowController

#pragma mark Initializers
+ ( id ) mainWindowController
    {
    return [ [ [ [ self class ] alloc ] init ] autorelease ];
    }

- ( id ) init
    {
    if ( self = [ super initWithWindowNibName: @"USLMainWindow" ] )
        {
        // TODO:
        }

    return self;
    }

#pragma mark Conforms <NSNibAwaking> protocol
- ( void ) awakeFromNib
    {
    // TODO:
    }

#pragma mark IBActions

- ( IBAction ) goAction: ( id )_Sender
    {
    NSString* URLString = self.URLField.stringValue;
    NSURL* URL = [ NSURL URLWithString: URLString ];

    NSURLSession* defaultSession =
        [ NSURLSession sessionWithConfiguration: [ NSURLSessionConfiguration defaultSessionConfiguration ] ];

    self.dataTask = [ defaultSession dataTaskWithURL: URL
                                   completionHandler:
        ^( NSData* _Data, NSURLResponse* _Response, NSError* _Error )
            {
            if ( !_Error )
                {
                NSURLCache* sharedCache = [ NSURLCache sharedURLCache ];

                NSURLRequest* currentRequest = [ self.dataTask currentRequest ];
                [ sharedCache storeCachedResponse:
                    [ [ [ NSCachedURLResponse alloc ] initWithResponse: _Response
                                                                  data: _Data
                                                              userInfo: @{ @"Cache Test" : @"USLMainWindowController" }
                                                         storagePolicy: NSURLCacheStorageAllowed ] autorelease ]
                                       forRequest: currentRequest ];
                }
            else
                [ self.window performSelectorOnMainThread: @selector( presentError: ) withObject: _Error waitUntilDone: YES ];
            } ];

    [ self.dataTask resume ];
    }

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