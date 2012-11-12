//
//  LPSmartLayer.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LPSmartLayer : CALayer
@property (nonatomic,readonly) int smLineWidth;
@property (nonatomic,strong,readonly) UIColor* smColor;
@property (nonatomic,strong) NSString* smName;
@property (nonatomic,assign) CALayer* smCurrSLayer;
@property (nonatomic,assign) CGMutablePathRef signPath;

- (id)initWithName:(NSString*)nName withColor:(UIColor*)nColor withLineWidth:(int)nWidth;
- (void)clear;
@end
