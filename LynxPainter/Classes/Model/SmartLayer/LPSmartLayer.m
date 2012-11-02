//
//  LPSmartLayer.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPSmartLayer.h"

@interface LPSmartLayer ()
@property (nonatomic) int smLineWidth;
@property (nonatomic,strong) UIColor* smColor;
@end
@implementation LPSmartLayer

- (void)fillWithColor:(UIColor*)nColor withLineWidth:(int)nWidth{
    self.smColor = nColor;
    self.smLineWidth = nWidth;
}

@end
