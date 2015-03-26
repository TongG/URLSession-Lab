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
#import "USLLabWindowController.h"

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

- ( NSString* ) TG_percentEncodeString: ( NSString* )_String
    {
    NSArray* reservedChars = @[ @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"

                              , @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M"
                              , @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"

                              , @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m"
                              , @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z"

                              , @"-", @".", @"_", @"~"
                              ];

    NSMutableString* percentEncodedString = [ NSMutableString string ];
    for ( int _Index = 0; _Index < _String.length; _Index++ )
        {
        NSString* charElem = [ _String substringWithRange: NSMakeRange( _Index, 1 ) ];

        if ( [ reservedChars containsObject: charElem ] )
            [ percentEncodedString appendString: charElem ];
        else
            {
            char const* UTF8Char = [ charElem UTF8String ];
            NSMutableString* percentEncodedChar = [ NSMutableString stringWithString: @"%" ];
            [ percentEncodedChar appendString: [ NSString stringWithFormat: @"%x", *UTF8Char ] ];
            percentEncodedChar = [ percentEncodedChar.uppercaseString mutableCopy ];

            [ percentEncodedString appendString: percentEncodedChar ];
            }
        }

    return percentEncodedString;
    }

- ( NSString* ) TG_percentEncodeURL: ( NSURL* )_URL
    {
    NSString* absoluteString = [ _URL absoluteString ];
    return [ self TG_percentEncodeString: absoluteString ];
    }

- ( NSString* ) signatureBaseString: ( NSString* )_HTTPMethod
                            baseURL: ( NSURL* )_APIURL
                  requestParameters: ( NSArray* )_RequestParams
    {
    NSMutableString* signatureBaseString = [ NSMutableString stringWithString: _HTTPMethod ];
    [ signatureBaseString appendString: @"&" ];
    [ signatureBaseString appendString: [ self TG_percentEncodeURL: _APIURL ] ];
    [ signatureBaseString appendString: @"&" ];

    for ( NSDictionary* _Param in _RequestParams )
        {
        NSString* key = [ _Param allKeys ].firstObject;
        [ signatureBaseString appendString: key ];
        [ signatureBaseString appendString: [ self TG_percentEncodeString: @"=" ] ];
        [ signatureBaseString appendString: [ self TG_percentEncodeString: _Param[ key ] ] ];
        [ signatureBaseString appendString: [ self TG_percentEncodeString: @"&" ] ];
        }

    [ signatureBaseString deleteCharactersInRange: NSMakeRange( signatureBaseString.length - 3, 3 ) ];
    return [ [ signatureBaseString copy ] autorelease ];
    }

- ( NSString* ) authorizationHeaders: ( NSArray* )_RequestParams
    {
    NSMutableString* authorizationHeader = [ NSMutableString stringWithFormat: @"OAuth " ];

    for ( NSDictionary* _Param in _RequestParams )
        {
        NSString* key = [ _Param allKeys ].firstObject;
        [ authorizationHeader appendString: [ NSString stringWithFormat: @"%@=\"%@\", ", key, _Param[ key ] ] ];
        }

    [ authorizationHeader deleteCharactersInRange: NSMakeRange( authorizationHeader.length - 1, 1 ) ];

    return [ [ authorizationHeader copy ] autorelease ];
    }

- ( IBAction ) requestTokenAction: ( id )_Sender
    {
    NSURL* baseURL = [ NSURL URLWithString: @"https://api.twitter.com/oauth/request_token" ];

    NSString* HTTPMethod = @"POST";
    NSString* OAuthCallback = @"oob";
    NSString* OAuthConsumerKey = @"hgHSOcN9Qc4S0W3MXykn7ajUi";
    NSString* OAuthNonce = [ self nonce ];
    NSString* OAuthSignatureMethod = @"HMAC-SHA1";
    NSString* OAuthTimestamp = [ self timestamp ];
    NSString* OAuthVersion = @"1.0";

    NSArray* requestParameters = @[ @{ @"oauth_callback" : OAuthCallback }
                                  , @{ @"oauth_consumer_key" : OAuthConsumerKey }
                                  , @{ @"oauth_nonce" : OAuthNonce }
                                  , @{ @"oauth_signature_method" : OAuthSignatureMethod }
                                  , @{ @"oauth_timestamp" : OAuthTimestamp }
                                  , @{ @"oauth_version" : OAuthVersion }
                                  ];

    NSString* signatureBaseString = [ self signatureBaseString: HTTPMethod
                                                       baseURL: baseURL
                                             requestParameters: requestParameters ];

    NSString* consumerSecret = [ NSString stringWithContentsOfFile: [ NSHomeDirectory() stringByAppendingString: @"/Pictures/consumer_secret.txt" ]
                                                          encoding: NSUTF8StringEncoding
                                                             error: nil ];

    NSString* OAuthSignature = nil;
    NSMutableString* signingKey = [ NSMutableString stringWithFormat: @"%@&", consumerSecret ];
    OAuthSignature = [ self signWithHMACSHA1: signatureBaseString signingKey: signingKey ];
    OAuthSignature = [ self TG_percentEncodeString: OAuthSignature ];

    NSString* authorizationHeader = [ self authorizationHeaders: [ requestParameters arrayByAddingObject: @{ @"oauth_signature" : OAuthSignature } ] ];

    NSMutableURLRequest* tokenRequest = [ NSMutableURLRequest requestWithURL: baseURL ];
    [ tokenRequest setHTTPMethod: @"POST" ];
    [ tokenRequest setValue: authorizationHeader forHTTPHeaderField: @"Authorization" ];
    self.dataTask = [ self.defaultSession dataTaskWithRequest: tokenRequest
                                            completionHandler:
        ^( NSData* _Body, NSURLResponse* _Response, NSError* _Error )
            {
            NSError* error = nil;
            if ( !error )
                {
                if ( _Body.length )
                    {
                    NSString* token = [ [ [ NSString alloc ] initWithData: _Body encoding: NSUTF8StringEncoding ] autorelease ];

                    NSMutableString* authorizePath = [ NSMutableString stringWithString: @"https://api.twitter.com/oauth/authorize?" ];
                    [ authorizePath appendString: token ];
                    [ authorizePath appendString: @"&force_login=1&screen_name=@NSTongG" ];

                    NSURL* authorizeURL = [ NSURL URLWithString: authorizePath ];
                    [ [ NSWorkspace sharedWorkspace ] openURL: authorizeURL ];
                    [ self.requestTokenLabel setStringValue: [ authorizeURL absoluteString ] ];
                    }
                }
            else
                [ self performSelectorOnMainThread: @selector( presentError: ) withObject: error waitUntilDone: YES ];
            } ];

    [ self.dataTask resume ];
    }

- ( IBAction ) accessTokenAction: ( id )_Sender
    {
    NSURL* baseURL = [ NSURL URLWithString: @"https://api.twitter.com/oauth/access_token" ];

    NSString* PINCode = [ self.PINField stringValue ];

    NSString* requestURLPath = self.requestTokenLabel.stringValue;
    NSArray* components = [ requestURLPath componentsSeparatedByString: @"&" ];

    NSMutableString* requestToken = nil;
    NSMutableString* requestTokenSecret = nil;
    for ( int _Index = 0; _Index < 2; _Index++ )
        {
        NSArray* subComponents = [ components[ _Index ] componentsSeparatedByString: @"=" ];

        if ( _Index == 0 )
            requestToken = subComponents.lastObject;
        else if ( _Index == 1 )
            requestTokenSecret = subComponents.lastObject;
        }

    NSString* HTTPMethod = @"POST";
    NSString* OAuthCallback = @"oob";
    NSString* OAuthConsumerKey = @"hgHSOcN9Qc4S0W3MXykn7ajUi";
    NSString* OAuthNonce = [ self nonce ];
    NSString* OAuthRequestToken = requestToken;
    NSString* OAuthSignatureMethod = @"HMAC-SHA1";
    NSString* OAuthTimestamp = [ self timestamp ];
    NSString* OAuthPINCode = PINCode;
    NSString* OAuthVersion = @"1.0";

    NSArray* requestParameters = @[ @{ @"oauth_callback" : OAuthCallback }
                                  , @{ @"oauth_consumer_key" : OAuthConsumerKey }
                                  , @{ @"oauth_nonce" : OAuthNonce }
                                  , @{ @"oauth_signature_method" : OAuthSignatureMethod }
                                  , @{ @"oauth_timestamp" : OAuthTimestamp }
                                  , @{ @"oauth_token" : OAuthRequestToken }
                                  , @{ @"oauth_verifier" : OAuthPINCode }
                                  , @{ @"oauth_version" : OAuthVersion }
                                  ];

    NSString* signatureBaseString = [ self signatureBaseString: HTTPMethod
                                                       baseURL: baseURL
                                             requestParameters: requestParameters ];

    NSString* consumerSecret = [ NSString stringWithContentsOfFile: [ NSHomeDirectory() stringByAppendingString: @"/Pictures/consumer_secret.txt" ]
                                                          encoding: NSUTF8StringEncoding
                                                             error: nil ];
    NSString* OAuthSignature = nil;
    NSMutableString* signingKey = [ NSMutableString stringWithFormat: @"%@&%@", consumerSecret, requestTokenSecret ];
    OAuthSignature = [ self signWithHMACSHA1: signatureBaseString signingKey: signingKey ];
    OAuthSignature = [ self TG_percentEncodeString: OAuthSignature ];

    NSString* authorizationHeader = [ self authorizationHeaders: [ requestParameters arrayByAddingObject: @{ @"oauth_signature" : OAuthSignature } ] ];

    NSMutableURLRequest* tokenRequest = [ NSMutableURLRequest requestWithURL: baseURL ];
    [ tokenRequest setHTTPMethod: @"POST" ];
    [ tokenRequest setValue: authorizationHeader forHTTPHeaderField: @"Authorization" ];
    self.dataTask = [ self.defaultSession dataTaskWithRequest: tokenRequest
                                            completionHandler:
        ^( NSData* _Body, NSURLResponse* _Response, NSError* _Error )
            {
            NSError* error = nil;
            if ( !error )
                {
                if ( _Body.length )
                    {
                    NSString* token = [ [ [ NSString alloc ] initWithData: _Body encoding: NSUTF8StringEncoding ] autorelease ];
                    [ self.accessTokenLabel setStringValue: token ];
                    }
                }
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

- ( IBAction ) showLabWindow: ( id )_Sender
    {
    if ( !self.labWindowController )
        self.labWindowController = [ URLLabWindowController labWindowController ];

    [ self.labWindowController showWindow: self ];
    }

#import <CommonCrypto/CommonHMAC.h>

- ( IBAction ) signWithHMSCSHA1: ( id )_Sender
    {
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