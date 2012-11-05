//
//  LPSmartLayerDelegate.m
//  LynxPainter
//
//  Created by Администратор on 11/5/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPSmartLayerDelegate.h"

@implementation LPSmartLayerDelegate
@synthesize signPath;

-(void)drawLayer:(CALayer*)l inContext:(CGContextRef)context
{
    tmp = CGPathCreateMutableCopy(signPath);
    CGContextSetStrokeColorWithColor(context, self.currentColor.CGColor);
    CGContextSetLineWidth(context, self.currDrawSize);
    CGContextAddPath(context, tmp);
    CGContextStrokePath(context);
    
}

@end
