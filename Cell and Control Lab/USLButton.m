//
//  USLButton.m
//  URLSession Lab
//
//  Created by Tong G. on 3/28/15.
//  Copyright (c) 2015 Tong Guo. All rights reserved.
//

#import "USLButton.h"
#import "USLButtonCell.h"

@implementation USLButton

- ( instancetype ) initWithCoder: ( NSCoder* )_OriginalCoder
    {
    NSKeyedUnarchiver* newCoder = ( NSKeyedUnarchiver* )_OriginalCoder;

    Class superCellClass = [ [ self superclass ] cellClass ];
    NSString* superCellClassName = NSStringFromClass( superCellClass );

    [ newCoder setClass: [ [ self class ] cellClass ] forClassName: superCellClassName ];

    if ( self = [ super initWithCoder: newCoder ] )
        [ NSKeyedUnarchiver setClass: superCellClass forClassName: superCellClassName ];

    return self;
    }

+ ( Class ) cellClass
    {
    return [ USLButtonCell class ];
    }

@end
