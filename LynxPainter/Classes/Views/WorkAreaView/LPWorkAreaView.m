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

@interface LPWorkAreaView (){
    CGMutablePathRef signPath;
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
    if(self.isDrawable){
        signPath = [LPSmartLayerManager sharedManager].currLayer.signPath;
        CGPoint p = [self pointFromTouches:touches];
        //signPath = CGPathCreateMutable();
        CGPathMoveToPoint(signPath, NULL, p.x, p.y);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.isDrawable){
        CGPoint p = [self pointFromTouches:touches];
        CGPathAddLineToPoint(signPath, NULL, p.x, p.y);
        LPSmartLayerDelegate* del = [LPSmartLayerManager sharedManager].currLayer.smCurrSLayer.delegate;
        del.signPath = [LPSmartLayerManager sharedManager].currLayer.signPath;
        [[LPSmartLayerManager sharedManager].currLayer.smCurrSLayer setNeedsDisplay];
    }
}

- (void)needNewSubPathPath{
    signPath = CGPathCreateMutable();
    CALayer* nplayer = [CALayer layer];
    nplayer.delegate = [LPSmartLayerManager sharedManager].currLayer.delegate;
    nplayer.frame = self.bounds;
    [LPSmartLayerManager sharedManager].currLayer.smCurrSLayer = nplayer;
    [[LPSmartLayerManager sharedManager].currLayer addSublayer:nplayer];
}

- (void)requestNewPath{
    
}

@end
