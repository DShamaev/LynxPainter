//
//  LPOpenedProjectViewController.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPOpenedProjectViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *rootLayer;

@property (nonatomic) float currScale;
@property (nonatomic) int currRootLayerWidth;
@property (nonatomic) int currRootLayerHeight;

@end
