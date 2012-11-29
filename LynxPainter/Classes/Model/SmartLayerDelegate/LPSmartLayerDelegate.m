//
//  LPSmartLayerDelegate.m
//  LynxPainter
//
//  Created by Администратор on 11/5/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPSmartLayerDelegate.h"

@interface LPSmartLayerDelegate ()
- (int)pointCode:(CGPoint)p toRect:(CGRect)rect;
@end

@implementation LPSmartLayerDelegate
@synthesize signPath,points;

-(void)drawLayer:(CALayer*)l inContext:(CGContextRef)context
{
    CGContextSetStrokeColorWithColor(context, self.currentColor.CGColor);
    CGContextSetLineWidth(context, self.currDrawSize);
    if(self.mode == 0){
        [self getSP];
        
        /*CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
        for (int i2=0; i2<[self.eraserRects count]; i2++) {
            NSValue* nr = [self.eraserRects objectAtIndex:i2];
            CGRect eraserRect = [nr CGRectValue];
            CGContextStrokeRect(context, eraserRect);
        }
        CGContextSetStrokeColorWithColor(context, self.currentColor.CGColor);*/
        
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
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
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

- (void)getSP{
    signPath = CGPathCreateMutable();
    CGPoint p1,p2;
    BOOL wasInER;
    for (int i=0; i<[self.pathPoints count]; i++) {
        NSValue* np = [self.pathPoints objectAtIndex:i];
        CGPoint p = [np CGPointValue];
        if(i==0){
            CGPathMoveToPoint(signPath, nil, p.x, p.y);
            p1 = p;
            continue;
        }else{
            p2 = p;
        }
        wasInER = NO;
        if ([self.eraserRects count]>0) {
            for (int i2=0; i2<[self.eraserRects count]; i2++) {
                NSValue* nr = [self.eraserRects objectAtIndex:i2];
                CGRect eraserRect = [nr CGRectValue];
                while (i<[self.pathPoints count] && CGRectContainsPoint(eraserRect,p2)) {
                    [self.pathPoints removeObjectAtIndex:i];
                    if (i<[self.pathPoints count]) {
                        NSValue* np = [self.pathPoints objectAtIndex:i];
                        p2 = [np CGPointValue];
                    }else
                        p2 = CGPointZero;
                }
                if(!CGPointEqualToPoint(p2, CGPointZero) && [self clipLineBetweenPointA:p1 andPointB:p2 withRect:eraserRect]) {
                    wasInER = YES;
                    [self.pathPoints replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:p2]];
                    [self.pathPoints replaceObjectAtIndex:i-1 withObject:[NSValue valueWithCGPoint:p1]];
                    break;
                }
                if (CGPointEqualToPoint(p2, CGPointZero)) {
                    break;
                }
            }
            if (CGPointEqualToPoint(p2, CGPointZero)) {
                break;
            }
            if (wasInER) {
                CGPathAddLineToPoint(signPath, nil, p1.x, p1.y);
                CGPathMoveToPoint(signPath, nil, p2.x, p2.y);
            }else{
                CGPathAddLineToPoint(signPath, nil, p2.x, p2.y);
            }
        }else{
            CGPathAddLineToPoint(signPath, nil, p2.x, p2.y);
        }
        p1 = p2;
    }
    //[self.eraserRects removeAllObjects];
}

- (BOOL) clipLineBetweenPointA:(CGPoint)pa andPointB:(CGPoint)pb withRect:(CGRect)rect{

    int code_a, code_b, code; /* код конечных точек отрезка */
    CGPoint c; /* одна из точек */
        
    code_a = [self pointCode:pa toRect:rect];
    code_b = [self pointCode:pb toRect:rect];
        
    /* пока одна из точек отрезка вне прямоугольника */
    while (code_a | code_b) {
        /* если обе точки с одной стороны прямоугольника, то отрезок не пересекает прямоугольник */
        if (code_a & code_b)
            return NO;
        
        /* выбираем точку c с ненулевым кодом */
        if (code_a) {
            code = code_a;
            c = pa;
        } else {
            code = code_b;
            c = pb;
        }
        
        /* если c левее r, то передвигаем c на прямую x = r.x_min
         если c правее r, то передвигаем c на прямую x = r.x_max */
        if (code & LEFT) {
            c.y += (pa.y - pb.y) * (CGRectGetMinX(rect) - c.x) / (pa.x - pb.x);
            c.x = CGRectGetMinX(rect);
        } else if (code & RIGHT) {
            c.y += (pa.y - pb.y) * (CGRectGetMaxX(rect) - c.x) / (pa.x - pb.x);
            c.x = CGRectGetMaxX(rect);
        }/* если c ниже r, то передвигаем c на прямую y = r.y_min
          если c выше r, то передвигаем c на прямую y = r.y_max */
        else if (code & BOT) {
            c.x += (pa.x - pb.x) * (CGRectGetMinY(rect) - c.y) / (pa.y - pb.y);
            c.y = CGRectGetMinY(rect);
        } else if (code & TOP) {
            c.x += (pa.x - pb.x) * (CGRectGetMaxY(rect) - c.y) / (pa.y - pb.y);
            c.y = CGRectGetMaxY(rect);
        }
        
        /* обновляем код */
        if (code == code_a){
            code_a = [self pointCode:c toRect:rect];
            pa = c;
        }else{
            code_b = [self pointCode:c toRect:rect];
            pb = c;
        }
    }
    
    /* оба кода равны 0, следовательно обе точки в прямоугольнике */
    return YES;
}

- (int)pointCode:(CGPoint)p toRect:(CGRect)rect{
    return (((p.x < CGRectGetMinX(rect)) ? LEFT : 0)  +
            ((p.x > CGRectGetMaxX(rect)) ? RIGHT : 0) +
            ((p.y < CGRectGetMinY(rect)) ? BOT : 0)   +
            ((p.y > CGRectGetMaxY(rect)) ? TOP : 0));
}

@end
