//
//  LPDrawingManagerViewController.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 11/13/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPOpenedProjectViewController;

@interface LPDrawingManagerViewController : UIViewController<UITextFieldDelegate>
@property (strong,nonatomic) LPOpenedProjectViewController* delegate;
@property (strong, nonatomic) IBOutlet UITextField *brsizeTF;
@property (strong, nonatomic) IBOutlet UIView *currColorView;
@property (strong, nonatomic) IBOutlet UISlider *hueSlider;
@property (strong, nonatomic) IBOutlet UISlider *saturationSlider;
@property (strong, nonatomic) IBOutlet UISlider *valueSlider;
@property (strong, nonatomic) IBOutlet UILabel *hueLabel;
@property (strong, nonatomic) IBOutlet UILabel *saturationLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
- (IBAction)redColorBtn:(id)sender;
- (IBAction)blueColorBtn:(id)sender;
- (IBAction)greenColorBtn:(id)sender;
- (IBAction)yellowColorBtn:(id)sender;
- (IBAction)blackColorBtn:(id)sender;
- (IBAction)WhiteColorBtn:(id)sender;
- (IBAction)hueValueChanged:(id)sender;
- (IBAction)saturationValueChanged:(id)sender;
- (IBAction)valueValueChanged:(id)sender;

@end
