//
//  LPSmartLayer.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class LPSmartLayerDelegate;

@interface LPSmartLayer : CALayer
@property (nonatomic) int smLineWidth;
@property (nonatomic,strong) UIColor* smColor;
@property (nonatomic,strong) NSString* smName;
@property (nonatomic,assign) CALayer* smCurrSLayer;
@property (nonatomic,assign) CGMutablePathRef signPath;
@property (nonatomic,strong) LPSmartLayerDelegate* del;

- (id)initWithName:(NSString*)nName withColor:(UIColor*)nColor withLineWidth:(int)nWidth;
- (void)clear;
- (void)removeLastChanges;
- (void)requestNewDelegate;
@end
