//
//  LPSmartLayerDelegate.m
//  LynxPainter
//
//  Created by Администратор on 11/5/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPSmartLayerDelegate.h"

@implementation LPSmartLayerDelegate
@synthesize signPath,points;

-(void)drawLayer:(CALayer*)l inContext:(CGContextRef)context
{
    if(self.mode == 0){
        CGContextSetStrokeColorWithColor(context, self.currentColor.CGColor);
        CGContextSetLineWidth(context, self.currDrawSize);
        CGContextAddPath(context, signPath);
        CGContextSetLineCap(context,kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineCapRound);
        CGContextStrokePath(context);
    }
    if(self.mode == 1){
        CGContextClipToRect(context, self.points);
    }
}

@end
