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

- ( IBAction ) requestTwitterTokenAction: ( id )_Sender
    {
    NSURL* URL = [ NSURL URLWithString: @"https://api.twitter.com/oauth/request_token" ];
    NSMutableURLRequest* tokenRequest = [ NSMutableURLRequest requestWithURL: URL ];
    [ tokenRequest setAllHTTPHeaderFields: @{ @"Authorization" : @"OAuth oauth_consumer_key=\"hgHSOcN9Qc4S0W3MXykn7ajUi\", oauth_nonce=\"kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg1997787\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"1427115174\", oauth_version=\"1.0\"" } ];
    self.dataTask = [ self.defaultSession dataTaskWithRequest: tokenRequest
                                            completionHandler:
        ^( NSData* _Body, NSURLResponse* _Response, NSError* _Error )
            {
            NSError* error = nil;
//            NSArray* JSON = [ NSJSONSerialization JSONObjectWithData: _Body options: 0 error: &error ];
            if ( !error )
                NSLog( @"Request Token: %@", [ [ [ NSString alloc ] initWithData: _Body encoding: NSUTF8StringEncoding ] autorelease ]);
            else
                [ self performSelectorOnMainThread: @selector( presentError: ) withObject: error waitUntilDone: YES ];
            } ];

    [ self.dataTask resume ];
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

#import <CommonCrypto/CommonHMAC.h>

- ( IBAction ) signWithHMSCSHA1: ( id )_Sender
    {
    NSLog( @"%@", [ self timestamp ] );
    NSLog( @"Nonce: %@", [ self nonce ] );
    NSLog( @"%@", [ self signWithHMACSHA1: self.URLField.stringValue signingKey: self.signingKeyField.stringValue ] );
    }

- ( NSString* ) signWithHMACSHA1: ( NSString* )_SignatureBaseString
                      signingKey: ( NSString* )_SigningKey
    {
    unsigned char buffer[ CC_SHA1_DIGEST_LENGTH ];
    CCHmac( kCCHmacAlgSHA1
          , _SigningKey.UTF8String, _SigningKey.length
          , _SignatureBaseString.UTF8String, _SignatureBaseString.length
          , buffer
          );

    NSData* signatureData = [ NSData dataWithBytes: buffer length: CC_SHA1_DIGEST_LENGTH ];
    NSString* base64 = [ signatureData base64EncodedStringWithOptions: NSDataBase64Encoding64CharacterLineLength ];

    return base64;
    }

- ( NSString* ) timestamp
    {
    NSTimeInterval UnixEpoch = [ [ NSDate date ] timeIntervalSince1970 ];
    NSString* timestamp = [ NSString stringWithFormat: @"%lu", ( NSUInteger )floor( UnixEpoch ) ];
    return timestamp;
    }

- ( NSString* ) nonce
    {
    CFUUIDRef UUID = CFUUIDCreate( kCFAllocatorDefault );
    CFStringRef cfStringRep = CFUUIDCreateString( kCFAllocatorDefault, UUID ) ;
    NSString* stringRepresentation = [ ( __bridge NSString* )cfStringRep copy ];

    if ( UUID )
        CFRelease( UUID );

    if ( cfStringRep )
        CFRelease( cfStringRep );

    return stringRepresentation;
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