//
//  LPWorkAreaView.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 11/10/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPWorkAreaView : UIView

typedef enum {
    WADBrush,
    WADRect,
    WADEllipse,
    WADLine,
    WADEraser,
} WADMode;

@property (nonatomic) BOOL isDrawable;
@property (nonatomic) WADMode currMode;
@property (nonatomic) CGPoint startPoint;
- (void)needNewSubPathPath;

@end
