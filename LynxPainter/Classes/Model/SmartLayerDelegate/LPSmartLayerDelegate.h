//
//  LPSmartLayerDelegate.h
//  LynxPainter
//
//  Created by Администратор on 11/5/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LEFT  1  /* 0001 */
#define RIGHT 2  /* 0010 */
#define BOT   4  /* 0100 */
#define TOP   8  /* 1000 */

@interface LPSmartLayerDelegate : NSObject
//0 - drawing pencil; 1 - eraser; 2 - rect mask; 3 - rect
@property (nonatomic) int mode;
@property(nonatomic,assign) CGMutablePathRef signPath;
@property (nonatomic,strong) NSMutableArray* pathPoints;
@property (nonatomic,strong) UIColor* currentColor;
@property (nonatomic,assign) int currDrawSize;
@property (nonatomic) CGRect points;
@property (nonatomic,strong) NSMutableArray* eraserRects;

@end
