//
//  LPSmartLayerDelegate.m
//  LynxPainter
//
//  Created by Администратор on 11/5/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPSmartLayerDelegate.h"

@implementation LPSmartLayerDelegate

-(void)drawLayer:(CALayer*)l inContext:(CGContextRef)context
{
    tmp = CGPathCreateMutableCopy(signPath);
    CGContextSetStrokeColorWithColor(context, currentColor.CGColor);
    CGContextSetLineWidth(context, currDrawSize);
    CGContextAddPath(context, tmp);
    CGContextStrokePath(context);
    
}

@end
