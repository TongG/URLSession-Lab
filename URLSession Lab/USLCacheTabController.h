//
//  USLCacheTabController.h
//  URLSession Lab
//
//  Created by Tong G. on 3/19/15.
//  Copyright (c) 2015 Tong Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MASPreferencesViewController.h"

@interface USLCacheTabController : NSViewController <MASPreferencesViewController>

@property ( nonatomic, readonly ) NSString* identifier;
@property ( nonatomic, readonly ) NSImage* toolbarItemImage;
@property ( nonatomic, readonly ) NSString* toolbarItemLabel;

- ( IBAction ) clearAllCache: ( id )_Sender;

@end
