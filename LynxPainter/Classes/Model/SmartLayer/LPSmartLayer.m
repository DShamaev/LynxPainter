//
//  LPSmartLayer.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPSmartLayer.h"
#import "LPSmartLayerDelegate.h"
#import "LPSmartLayerManager.h"
#import "LPWorkAreaView.h"

@interface LPSmartLayer (){
    NSMutableArray* layerDelegates;
}

- (void)initialization;
- (CGPoint)pointFromTouches:(NSSet*)touches;

@end


@implementation LPSmartLayer

- (id)initWithName:(NSString*)nName withColor:(UIColor*)nColor withLineWidth:(int)nWidth{
    self = [super init];
    if(self){
        self.smName = nName;
        self.smColor = nColor;
        self.smLineWidth = nWidth;
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
    self.signPath = CGPathCreateMutable();
    [self setBackgroundColor:[UIColor clearColor].CGColor];
    self.del = [[LPSmartLayerDelegate alloc] init];
    self.del.currentColor = self.smColor;
    self.del.currDrawSize = self.smLineWidth;
    layerDelegates = [NSMutableArray array];
    [layerDelegates addObject:self.del];
    NSArray* sl = [self sublayers];
    for (int i=0; i<[sl count]; i++) {
        [[self.sublayers objectAtIndex:i] removeFromSuperlayer];
    }
    CALayer* player = [CALayer layer];
    player.delegate = [layerDelegates objectAtIndex:0];
    player.frame = [LPSmartLayerManager sharedManager].rootView.bounds;
    self.smCurrSLayer = player;
    [self addSublayer:player];
    [self requestNewDelegate];
    self.delegate  = [layerDelegates lastObject];
}

- (void)clean {
    [self initialization];
    [self setNeedsDisplay];
}

- (void)requestNewDelegate{
    self.del = [[LPSmartLayerDelegate alloc] init];
    self.del.currentColor = self.smColor;
    self.del.currDrawSize = self.smLineWidth;
    [layerDelegates addObject:self.del];
}

- (void)removeLastChanges{
    if([self.sublayers count]>1){
        CALayer* lo = [self.sublayers objectAtIndex:[self.sublayers count]-2];
        [lo removeFromSuperlayer];
    }
}

@end
