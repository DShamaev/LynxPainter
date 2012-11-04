//
//  LPOpenedProjectViewController.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPOpenedProjectViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *rootLayer;

@property (nonatomic) float currScale;
@property (nonatomic) int currRootLayerWidth;
@property (nonatomic) int currRootLayerHeight;
@property (strong, nonatomic) IBOutlet UITextField *scaleValueTF;
@property (strong, nonatomic) IBOutlet UIScrollView *workAreaSV;
- (IBAction)closeProject:(id)sender;

@end
