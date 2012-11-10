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

@interface LPSmartLayer (){
    LPSmartLayerDelegate* del;
}

@property (nonatomic) int smLineWidth;
@property (nonatomic,strong) UIColor* smColor;

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
    [self setBackgroundColor:[UIColor clearColor].CGColor];
    del = [[LPSmartLayerDelegate alloc] init];
    del.currentColor = self.smColor;
    del.currDrawSize = self.smLineWidth;
    self.delegate = del;
    NSArray* sl = [self sublayers];
    for (int i=0; i<[sl count]; i++) {
        [[self.sublayers objectAtIndex:i] removeFromSuperlayer];
    }
    CALayer* player = [CALayer layer];
    player.delegate = self.delegate;
    player.frame = [LPSmartLayerManager sharedManager].rootView.bounds;
    CGRect f = player.frame;
    self.smCurrSLayer = player;
    [self addSublayer:player];
}

- (void) dealloc {
}

- (void)clean {
    [self initialization];
    [self setNeedsDisplay];
}


@end
