//
//  LPSmartLayerDelegate.h
//  LynxPainter
//
//  Created by Администратор on 11/5/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPSmartLayerDelegate : NSObject
//0 - drawing pencil; 1 - eraser
@property (nonatomic) int mode;
@property(nonatomic,assign) CGMutablePathRef signPath;
@property (nonatomic,strong) UIColor* currentColor;
@property (nonatomic,assign) int currDrawSize;
@property (nonatomic) CGRect points;

@end
