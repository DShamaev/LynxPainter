//
//  LPSmartLayerDelegate.h
//  LynxPainter
//
//  Created by Администратор on 11/5/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPSmartLayerDelegate : NSObject{
    CGMutablePathRef signPath;
    CGMutablePathRef tmp;
}
@property(nonatomic) CGMutablePathRef signPath;
@property (nonatomic,strong) UIColor* currentColor;
@property (nonatomic,assign) int currDrawSize;

@end
