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
 **                       Copyright 2015 (c) Tong G.                        **
 **                          ALL RIGHTS RESERVED.                           **
 **                                                                         **
 ****************************************************************************/

#import "USLMainWindowController.h"

// USLMainWindowController class
@implementation USLMainWindowController

@synthesize backgroundSession;
@synthesize defaultSession;
@synthesize ephemeralSession;

@synthesize completionHandlerDictionary;

@synthesize resumeData = _resumeData;

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
    self.completionHandlerDictionary = [ NSMutableDictionary dictionary ];

    /* Create some configuration objects. */
    NSURLSessionConfiguration* defaultConfig = [ NSURLSessionConfiguration defaultSessionConfiguration ];
    NSURLSessionConfiguration* backgroundConfig = [ NSURLSessionConfiguration backgroundSessionConfiguration: @"individual.TongGuo.USLSession-Lab" ];
    NSURLSessionConfiguration* ephemeralConfig = [ NSURLSessionConfiguration ephemeralSessionConfiguration ];

    /* Configure caching behavior for the default session.
       Note that iOS requires the cache path to be a path relative
       to the ~/Library/Caches directory, but OS X expects an
       absolute path.
     */
    NSString* cachePath = [ NSHomeDirectory() stringByAppendingString: @"Caches" ];

    NSURLCache* caches = [ [ [ NSURLCache alloc ] initWithMemoryCapacity: 20 * 1024
                                                            diskCapacity: 10 * powl( 1024, 2 )
                                                                diskPath: cachePath ] autorelease ];
    [ defaultConfig setURLCache: caches ];
    [ defaultConfig setRequestCachePolicy: NSURLRequestUseProtocolCachePolicy ];

    self.defaultSession = [ NSURLSession sessionWithConfiguration: defaultConfig delegate: self delegateQueue: [ NSOperationQueue mainQueue ] ];
    self.backgroundSession = [ NSURLSession sessionWithConfiguration: backgroundConfig ];
    self.ephemeralSession = [ NSURLSession sessionWithConfiguration: ephemeralConfig ];

    self.receivedData = [ NSMutableData data ];
    }

#pragma mark IBActions

- ( void ) URLSession: ( NSURLSession* )_Session
             dataTask: ( NSURLSessionDataTask* )_DataTask
       didReceiveData: ( NSData* )_DataPiece
    {
    NSError* error = nil;
    NSArray* JSONValue = [ NSJSONSerialization JSONObjectWithData: _DataPiece options: 0 error: &error ];

    if ( !error )
        NSLog( @"JSON: %@", JSONValue );

    [ self.receivedData appendData: _DataPiece ];
    NSLog( @"%@     %lu", _DataTask, self.receivedData.length );
    }

- ( void )    URLSession: ( NSURLSession* )_Session
                    task: ( NSURLSessionTask* )_Task
    didCompleteWithError: ( NSError* )_Error
    {
    if ( _Error.userInfo[ NSURLSessionDownloadTaskResumeData ] )
        self.resumeData = _Error.userInfo[ NSURLSessionDownloadTaskResumeData ];

    fprintf( stdout, "\n\n============ Completed! ==========\n\n\n" );
    NSLog( @"Bytes: %lu", self.receivedData.length );
    fprintf( stdout, "\n\n============ Completed! ==========\n\n\n" );

    if ( _Error )
        [ self presentError: _Error ];
    }

- ( void )         URLSession: ( NSURLSession* )_Session
                 downloadTask: ( NSURLSessionDownloadTask* )_DownloadTask
    didFinishDownloadingToURL: ( NSURL* )_Location
    {
    NSURLRequest* request = _DownloadTask.currentRequest;
    NSURLSessionConfiguration* configuration = _Session.configuration;

    fprintf( stdout, "\n\n============ Completed! ==========\n" );
    NSLog( @"Request: %@", request );
    NSLog( @"Location: %@", _Location );
    fprintf( stdout, "============ Completed! ==========\n\n\n" );
    }

- ( void ) URLSession: ( NSURLSession* )_Session
         downloadTask: ( NSURLSessionDownloadTask* )_ResumedDownloadTask
    didResumeAtOffset: ( int64_t )_FileOffset
  expectedTotalBytes:( int64_t )_ExpectedTotalBytes
    {

    }

- ( void )         URLSession: ( NSURLSession* )_Session
                 downloadTask: ( NSURLSessionDownloadTask* )_DownloadTask
                 didWriteData: ( int64_t )_BytesWritten
            totalBytesWritten: ( int64_t )_TotalBytesWritten
    totalBytesExpectedToWrite: ( int64_t )_TotalBytesExpectedToWrite
    {
    fprintf( stdout, "\n\n=================================\n" );
    NSLog( @"Bytes Written: %llu", _BytesWritten );
    NSLog( @"Total Bytes Written: %llu", _TotalBytesWritten );
    NSLog( @"Total Bytes Expected To Write: %llu", _TotalBytesExpectedToWrite );
    fprintf( stdout, "===============================\n\n\n" );
    }

#pragma mark Data Task
- ( IBAction ) goAction: ( id )_Sender
    {
    NSString* URLString = self.URLField.stringValue;
    NSURL* URL = [ NSURL URLWithString: URLString ];

    self.dataTask = [ self.defaultSession dataTaskWithURL: URL ];

    [ self.dataTask resume ];
    }

- ( IBAction ) pauseAction: ( id )_Sender
    {
    [ self.dataTask suspend ];
    }

- ( IBAction ) resumeAction: ( id )_Sender
    {
    [ self.dataTask resume ];
    }

- ( IBAction ) stopAction: ( id )_Sender
    {
    [ self.dataTask cancel ];
    }

#pragma mark Download Task
- ( IBAction ) downloadAction: ( id )_Sender
    {
    NSString* URLString = self.URLField.stringValue;
    NSURL* URL = [ NSURL URLWithString: URLString ];

    self.downloadTask = [ self.defaultSession downloadTaskWithURL: URL ];
    [ self.downloadTask resume ];
    }

- ( IBAction ) pauseDownloadAction: ( id )_Sender
    {
    [ self.downloadTask suspend ];
    }

- ( IBAction ) resumeDownloadAction: ( id )_Sender
    {
    self.downloadTask = [ self.defaultSession downloadTaskWithResumeData: self.resumeData ];
    [ self.downloadTask resume ];
    }

- ( IBAction ) stopDownloadAction: ( id )_Sender
    {
    [ self.downloadTask cancelByProducingResumeData:
        ^( NSData* _ResumeData )
            {
            self.resumeData = _ResumeData;
            } ];
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