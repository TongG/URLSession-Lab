//
//  USLButtonCell.m
//  URLSession Lab
//
//  Created by Tong G. on 3/28/15.
//  Copyright (c) 2015 Tong Guo. All rights reserved.
//

#import "USLButtonCell.h"

@implementation USLButtonCell

- ( void ) awakeFromNib
    {
    NSLog( @"Cell Type: %lu", self.type );
    NSImage* image = [ NSImage imageNamed: NSImageNameActionTemplate ];
    [ self setImage: image ];
    NSLog( @"Cell Type: %lu", self.type );
//    NSLog( @"Cell Type: %lu", self.type );
//    NSLog( @"\n\n" );
    }

- ( NSRect ) imageRectForBounds: ( NSRect )_Bounds
    {
    NSRect rect = _Bounds;

    rect.origin.x = NSMinX( _Bounds ) - 10;

    return rect;
    }

- ( void ) drawWithFrame: ( NSRect )_Frame
                  inView: ( NSView* )_View
    {
    [ super drawWithFrame: _Frame inView: _View ];
    }

- ( BOOL ) startTrackingAt: ( NSPoint )_StartPoint
                    inView: ( NSView* )_ControlView
    {
    BOOL yesOrNo = [ super startTrackingAt: _StartPoint inView: _ControlView ];
    NSLog( @"Start Point: %@    ControlView: %@     yesOrNo: %d", NSStringFromPoint( _StartPoint ), _ControlView, yesOrNo );

    return YES;
    }

- ( BOOL ) continueTracking: ( NSPoint )_LastPoint
                         at: ( NSPoint )_CurrentPoint
                     inView: ( NSView* )_ControlView
    {
    BOOL yesOrNo = [ super continueTracking: _LastPoint at: _CurrentPoint inView: _ControlView ];
    NSLog( @"Last Point: %@     Current Point: %@    ControlView: %@     yesOrNo: %d"
         , NSStringFromPoint( _LastPoint )
         , NSStringFromPoint( _CurrentPoint )
         , _ControlView, yesOrNo
         );

    return YES;
    }

- ( void ) stopTracking: ( NSPoint )_LastPoint
                     at: ( NSPoint )_StopPoint
                 inView: ( NSView* )_ControlView
              mouseIsUp: ( BOOL )_Flag
    {
    [ super stopTracking: _LastPoint at: _StopPoint inView: _ControlView mouseIsUp: _Flag ];

    NSLog( @"Last Point: %@     Stop Point: %@    ControlView: %@   Yes or No: %d"
         , NSStringFromPoint( _LastPoint )
         , NSStringFromPoint( _StopPoint )
         , _ControlView
         , _Flag
         );
    }

- ( BOOL ) trackMouse: ( NSEvent* )_Event
               inRect: ( NSRect )_Frame
               ofView: ( NSView* )_ControlView
         untilMouseUp: ( BOOL )_UntilMouseUp
    {
    return [ super trackMouse: _Event
                       inRect: _Frame
                       ofView: _ControlView
                 untilMouseUp: _UntilMouseUp ];
    }

@end
