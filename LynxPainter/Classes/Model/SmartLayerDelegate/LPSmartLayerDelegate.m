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
    CGContextSetStrokeColorWithColor(context, self.currentColor.CGColor);
    CGContextSetLineWidth(context, self.currDrawSize);
    if(self.mode == 0){
        CGContextAddPath(context, signPath);
        CGContextSetLineCap(context,kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineCapRound);
        CGContextStrokePath(context);
    }
    if(self.mode == 1){
        CGContextClipToRect(context, self.points);
    }
    if(self.mode == 2){
        CGFloat dashPatt[] = {20.0,8.0};
        CGContextSetLineDash(context, 0, dashPatt, 2);
        CGContextStrokeRect(context, self.points);
    }
    if(self.mode == 3){
        CGContextStrokeRect(context, self.points);
    }
    if(self.mode == 4){
        CGFloat dashPatt[] = {20.0,8.0};
        CGContextSetLineDash(context, 0, dashPatt, 2);
        CGContextStrokeEllipseInRect(context, self.points);
    }
    if(self.mode == 5){
        CGContextStrokeEllipseInRect(context, self.points);
    }
    if(self.mode == 6){
        CGFloat dashPatt[] = {20.0,8.0};
        CGContextSetLineDash(context, 0, dashPatt, 2);
        CGContextAddPath(context, signPath);
        CGContextSetLineCap(context,kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineCapRound);
        CGContextStrokePath(context);

    }
}

@end
