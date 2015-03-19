//
//  USLCacheTabController.m
//  URLSession Lab
//
//  Created by Tong G. on 3/19/15.
//  Copyright (c) 2015 Tong Guo. All rights reserved.
//

#import "USLCacheTabController.h"

@implementation USLCacheTabController

@dynamic identifier;
@dynamic toolbarItemImage;
@dynamic toolbarItemLabel;

- ( id ) init
    {
    if ( self = [ super initWithNibName: @"USLCacheTab" bundle: [ NSBundle mainBundle ] ] )
        ;

    return self;
    }

- ( NSString* ) identifier
    {
    return @"Tab Controller";
    }

- ( NSImage* ) toolbarItemImage
    {
    return [ NSImage imageNamed: NSImageNameTrashEmpty ];
    }

- ( NSString* ) toolbarItemLabel
    {
    return @"Cache Management";
    }

- ( IBAction ) clearAllCache: ( id )_Sender
    {
    [ [ NSURLCache sharedURLCache ] removeAllCachedResponses ];
    }

@end
