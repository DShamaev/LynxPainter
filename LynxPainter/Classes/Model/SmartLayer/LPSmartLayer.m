//
//  LPSmartLayer.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPSmartLayer.h"
#import "LPSmartLayerDelegate.h"

@interface LPSmartLayer (){
    CALayer* player;
    CGMutablePathRef signPath;
    LPSmartLayerDelegate* pld;
}
@property (nonatomic) int smLineWidth;
@property (nonatomic,strong) UIColor* smColor;

- (void)initialization;
- (CGPoint)pointFromTouches:(NSSet*)touches;

@end


@implementation LPSmartLayer

- (void)fillWithName:(NSString*)nName withColor:(UIColor*)nColor withLineWidth:(int)nWidth{
    self.smName = nName;
    self.smColor = nColor;
    self.smLineWidth = nWidth;
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
    player = [CALayer layer];
    player.opaque = YES;
    pld = [[LPSmartLayerDelegate alloc] init];
    player.delegate = pld;
    player.frame = self.bounds;
    [self addSublayer:player];
    signPath = CGPathCreateMutable();
}

- (void) dealloc {
    CGPathRelease(signPath);
}

- (CGPoint)pointFromTouches:(NSSet*)touches {
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    
    CGPoint p = [touch locationInView:self];
    return p;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint p = [self pointFromTouches:touches];
    //signPath = CGPathCreateMutable();
    CGPathMoveToPoint(signPath, NULL, p.x, p.y);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint p = [self pointFromTouches:touches];
    CGPathAddLineToPoint(signPath, NULL, p.x, p.y);
    pld.currDrawSize = self.smLineWidth;
    pld.currentColor = self.smColor;
    pld.signPath = signPath;
    [player setNeedsDisplay];
}

- (void)needNewPath{
    signPath = CGPathCreateMutable();
    CALayer* nplayer = [CALayer layer];
    nplayer.delegate = pld;
    nplayer.frame = self.bounds;
    [self insertSublayer:nplayer above:player];
    player = nplayer;
}

- (void)clean {
    [self initialization];
    [player setNeedsDisplay];
}


@end
