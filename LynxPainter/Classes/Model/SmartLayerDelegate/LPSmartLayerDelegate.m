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
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    signPath = CGPathCreateMutable();
    BOOL wasInER = NO;
    for (int i=0; i<[self.pathPoints count]; i++) {
        NSValue* np = [self.pathPoints objectAtIndex:i];
        CGPoint p = [np CGPointValue];
        if(i==0){
            CGPathMoveToPoint(signPath, nil, p.x, p.y);
            continue;
        }
        if ([self.eraserRects count]>0) {
            for (int i2=0; i2<[self.eraserRects count]; i2++) {
                NSValue* nr = [self.eraserRects objectAtIndex:i2];
                CGRect eraserRect = [nr CGRectValue];
                if(CGRectContainsPoint(eraserRect, p)) {
                    //CGPathCloseSubpath(signPath);
                    wasInER = YES;
                    break;
                }
            }
            if (wasInER) {
                CGPathMoveToPoint(signPath, nil, p.x, p.y);
            }else{
                CGPathAddLineToPoint(signPath, nil, p.x, p.y);
                wasInER = NO;
            }
        }else{
            CGPathAddLineToPoint(signPath, nil, p.x, p.y);
        }
    }
    if(self.mode == 0){
        CGContextAddPath(context, signPath);
        CGContextSetLineCap(context,kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineCapRound);
        CGContextStrokePath(context);
    }
    if(self.mode == 1){
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.currDrawSize);
        CGContextSetBlendMode(context, kCGBlendModeClear);
        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextAddPath(context, signPath);
        CGContextStrokePath(context);
    }
    if(self.mode == 3){
        CGContextStrokeRect(context, self.points);
    }
    if(self.mode == 5){
        CGContextStrokeEllipseInRect(context, self.points);
    }
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    if(self.mode == 2){
        CGFloat dashPatt[] = {20.0,8.0};
        CGContextSetLineDash(context, 0, dashPatt, 2);
        CGContextStrokeRect(context, self.points);
    }
    if(self.mode == 4){
        CGFloat dashPatt[] = {20.0,8.0};
        CGContextSetLineDash(context, 0, dashPatt, 2);
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
