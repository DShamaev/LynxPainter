//
//  LPWorkAreaView.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 11/10/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPWorkAreaView.h"
#import "LPSmartLayerManager.h"
#import "LPSmartLayer.h"
#import "LPSmartLayerDelegate.h"
#import "LPHistoryManager.h"
#import <QuartzCore/QuartzCore.h>

@interface LPWorkAreaView (){
    CGMutablePathRef signPath;
    BOOL isMaskDrawn;
    NSMutableArray* ppointsArray;
}

@end

@implementation LPWorkAreaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initialization];
    }
    return self;
}


- (id)init {
    self = [super init];
    if (self) {
        // Initialization code
        [self initialization];
    }
    return self;
}

- (void)initialization {
    signPath = CGPathCreateMutable();
    self.isDrawable = YES;
    self.isDraggable = NO;
    self.currMode = WADBrush;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (CGPoint)pointFromTouches:(NSSet*)touches {
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    
    CGPoint p = [touch locationInView:self];
    return p;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.startPoint = [self pointFromTouches:touches];
    if(self.isDrawable && ![LPSmartLayerManager sharedManager].currLayer.smReadOnly){
        isMaskDrawn = NO;
        if(self.currMode == WADBrush || self.currMode == WADLine /* || self.currMode == WADEraser */){
            if(!ppointsArray)
                ppointsArray = [NSMutableArray array];
            else
                [ppointsArray removeAllObjects];
            LPSmartLayerDelegate* del = [LPSmartLayerManager sharedManager].currLayer.smCurrSLayer.delegate;
            CGPoint p = [self pointFromTouches:touches];
            [del.pathPoints addObject:[NSValue valueWithCGPoint:p]];
            [ppointsArray addObject:[NSValue valueWithCGPoint:p]];
            //CGPathMoveToPoint(signPath, NULL, p.x, p.y);
        }
        if(self.currMode == WADEraser){
            LPSmartLayerDelegate* del = [LPSmartLayerManager sharedManager].currLayer.smCurrSLayer.delegate;
            CGPoint p = [self pointFromTouches:touches];
            [del.eraserPoints addObject:[NSValue valueWithCGPoint:p]];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.isDrawable && ![LPSmartLayerManager sharedManager].currLayer.smReadOnly){
        if(self.currMode == WADBrush){
            CGPoint p = [self pointFromTouches:touches];
            //CGPathAddLineToPoint(signPath, NULL, p.x, p.y);
            LPSmartLayerDelegate* del = [LPSmartLayerManager sharedManager].currLayer.smCurrSLayer.delegate;
            del.mode = 0;
            //del.signPath = signPath;
            [del.pathPoints addObject:[NSValue valueWithCGPoint:p]];
            del.currentColor = [LPSmartLayerManager sharedManager].currLayer.smColor;
            del.currDrawSize = [LPSmartLayerManager sharedManager].currLayer.smLineWidth;
            [[LPSmartLayerManager sharedManager].currLayer.smCurrSLayer setNeedsDisplay];
        }
        if(self.currMode == WADEraser){
            CGPoint point = [self pointFromTouches:touches];
            LPSmartLayerDelegate* del;
            NSArray* la = [LPSmartLayerManager sharedManager].currLayer.sublayers;
            for (int i=0; i<[la count]; i++) {
                CALayer* l = [la objectAtIndex:i];
                del = l.delegate;
                del.mode = 0;
                del.currEraserSize = [LPSmartLayerManager sharedManager].currLayer.smLineWidth;
                [del.eraserPoints addObject:[NSValue valueWithCGPoint:point]];
                [l setNeedsDisplay];
            }
            self.startPoint = point;
            
            /*CGPoint p = [self pointFromTouches:touches];
            LPSmartLayerDelegate* del = [LPSmartLayerManager sharedManager].currLayer.smCurrSLayer.delegate;
            del.mode = 1;
            [del.pathPoints addObject:[NSValue valueWithCGPoint:p]];
            del.currentColor = [LPSmartLayerManager sharedManager].currLayer.smColor;
            del.currDrawSize = [LPSmartLayerManager sharedManager].currLayer.smLineWidth;
            [[LPSmartLayerManager sharedManager].currLayer.smCurrSLayer setNeedsDisplay];*/
        }
        if(self.currMode == WADLine){
            if(isMaskDrawn)
                [[LPSmartLayerManager sharedManager] partialUndo];
            isMaskDrawn = YES;
            CGPoint p = [self pointFromTouches:touches];
            signPath = CGPathCreateMutable();
            CGPathMoveToPoint(signPath, NULL, self.startPoint.x, self.startPoint.y);
            CGPathAddLineToPoint(signPath, NULL, p.x, p.y);
            LPSmartLayerDelegate* del = [LPSmartLayerManager sharedManager].currLayer.smCurrSLayer.delegate;
            del.mode = 6;
            del.signPath = signPath;
            [del.pathPoints addObject:[NSValue valueWithCGPoint:p]];
            del.currentColor = [LPSmartLayerManager sharedManager].currLayer.smColor;
            del.currDrawSize = [LPSmartLayerManager sharedManager].currLayer.smLineWidth;
            [[LPSmartLayerManager sharedManager].currLayer.smCurrSLayer setNeedsDisplay];
            [self needNewSubPath];
        }
        if(self.currMode == WADRect || self.currMode == WADEllipse){
            if(isMaskDrawn)
                [[LPSmartLayerManager sharedManager] partialUndo];
            isMaskDrawn = YES;
            CGPoint point = [self pointFromTouches:touches];
            LPSmartLayerDelegate* del = [LPSmartLayerManager sharedManager].currLayer.smCurrSLayer.delegate;
            if(self.currMode == WADRect)
                del.mode = 2;
            if(self.currMode == WADEllipse)
                del.mode = 4;
            del.points = CGRectMake(self.startPoint.x, self.startPoint.y,point
                                    .x-self.startPoint.x, point.y-self.startPoint.y);
            del.currentColor = [LPSmartLayerManager sharedManager].currLayer.smColor;
            del.currDrawSize = [LPSmartLayerManager sharedManager].currLayer.smLineWidth;
            [[LPSmartLayerManager sharedManager].currLayer.smCurrSLayer setNeedsDisplay];
            [self needNewSubPath];
        }
    }
    if(self.isDraggable){
        CGPoint p = [self pointFromTouches:touches];
        [LPSmartLayerManager sharedManager].currLayer.transform = CATransform3DConcat([LPSmartLayerManager sharedManager].currLayer.transform, CATransform3DMakeTranslation(p.x-self.startPoint.x, p.y-self.startPoint.y, 0));
        self.startPoint = p;
        //(CG)CGAffineTransformConcat([LPSmartLayerManager sharedManager].currLayer.transform, CGAffineTransformMakeTranslation(p.x-self.startPoint.x, p.y-self.startPoint.y));
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(self.isDrawable && ![LPSmartLayerManager sharedManager].currLayer.smReadOnly){
        if(self.currMode == WADRect || self.currMode == WADEllipse){
            if(isMaskDrawn)
                [[LPSmartLayerManager sharedManager] partialUndo];
            CGPoint point = [self pointFromTouches:touches];
            LPSmartLayerDelegate* del = [LPSmartLayerManager sharedManager].currLayer.smCurrSLayer.delegate;
            if(self.currMode == WADRect)
                del.mode = 3;
            if(self.currMode == WADEllipse)
                del.mode = 5;
            del.points = CGRectMake(self.startPoint.x, self.startPoint.y,point
                                    .x-self.startPoint.x, point.y-self.startPoint.y);
            del.currentColor = [LPSmartLayerManager sharedManager].currLayer.smColor;
            del.currDrawSize = [LPSmartLayerManager sharedManager].currLayer.smLineWidth;
            [[LPSmartLayerManager sharedManager].currLayer.smCurrSLayer setNeedsDisplay];
        }
        if(self.currMode == WADLine){
            if(isMaskDrawn)
                [[LPSmartLayerManager sharedManager] partialUndo];
            isMaskDrawn = YES;
            CGPoint p = [self pointFromTouches:touches];
            LPSmartLayerDelegate* del = [LPSmartLayerManager sharedManager].currLayer.smCurrSLayer.delegate;
            del.mode = 0;
            //del.signPath = signPath;
            [ppointsArray addObject:[NSValue valueWithCGPoint:p]];
            [del.pathPoints addObjectsFromArray:ppointsArray];
            del.currentColor = [LPSmartLayerManager sharedManager].currLayer.smColor;
            del.currDrawSize = [LPSmartLayerManager sharedManager].currLayer.smLineWidth;
            [[LPSmartLayerManager sharedManager].currLayer.smCurrSLayer setNeedsDisplay];
        }
        if(self.currMode != WADEraser){
            [self needNewSubPath];
            [[LPHistoryManager sharedManager] addActionWithLayer:[LPSmartLayerManager sharedManager].currLayer.smName];            
        }
    }
}

- (void)needNewSubPath{
    CALayer* sl = [LPSmartLayerManager sharedManager].currLayer.smCurrSLayer;
    LPSmartLayerDelegate* del = [LPSmartLayerManager sharedManager].currLayer.smCurrSLayer.delegate;
    /*UIGraphicsBeginImageContext(self.bounds.size);
    float opac = sl.opacity;
    BOOL vis = sl.hidden;
    sl.hidden = NO;
    sl.opacity = 1.0;
    [sl renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();    
    sl.opacity = opac;
    sl.hidden = vis;
    UIGraphicsEndImageContext();
    [del.pathPoints removeAllObjects];
    [[LPSmartLayerManager sharedManager].currLayer.smCurrSLayer setNeedsDisplay];
    sl.contents = (id)image.CGImage;*/
    
    CALayer* nplayer = [CALayer layer];
    nplayer.frame = self.bounds;
    del = [[LPSmartLayerManager sharedManager].currLayer requestNewDelegate];
    del.signPath = CGPathCreateMutable();
    nplayer.delegate = del;
    [LPSmartLayerManager sharedManager].currLayer.smCurrSLayer = nplayer;
    [[LPSmartLayerManager sharedManager].currLayer addSublayer:nplayer ];
}

@end
