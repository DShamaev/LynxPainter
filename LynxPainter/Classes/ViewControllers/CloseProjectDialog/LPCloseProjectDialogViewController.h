//
//  LPCloseProjectDialogViewController.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 12.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPOpenedProjectViewController;

@interface LPCloseProjectDialogViewController : UIViewController
@property (strong,nonatomic) LPOpenedProjectViewController* delegate;
@property (strong, nonatomic) IBOutlet UITextField *cpdFilenameTF;
@property (strong, nonatomic) IBOutlet UISegmentedControl *formatSC;
- (IBAction)cancelBtnClicked:(id)sender;
- (IBAction)saveBtnClicked:(id)sender;
- (IBAction)dontsaveBtnClicked:(id)sender;

@end
