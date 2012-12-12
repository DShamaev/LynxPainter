//
//  LPWorkAreaView.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 11/10/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol WorkAreaDelegate <NSObject>

@required
-(void)closeAllTabs;
-(void)showLayerTansformButtons;
-(void)hideLayerTansformButtons;
@end

@interface LPWorkAreaView : UIView

typedef enum {
    WADBrush,
    WADRect,
    WADEllipse,
    WADLine,
    WADEraser,
} WADMode;

@property (nonatomic) id<WorkAreaDelegate> delegate;
@property (nonatomic) CATransform3D currTransform;
@property (nonatomic) BOOL isDrawable;
@property (nonatomic) BOOL isDraggable;
@property (nonatomic) WADMode currMode;
@property (nonatomic) CGPoint startPoint;
- (void)needNewSubPath;
- (void)cancelTransform;
- (void)acceptTransform;

@end
