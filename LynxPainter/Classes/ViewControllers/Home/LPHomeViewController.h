//
//  LPHomeViewController.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPHomeViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *createDialogView;
@property (strong, nonatomic) IBOutlet UITextField *rlWidthTF;
@property (strong, nonatomic) IBOutlet UITextField *rlHeightTF;
- (IBAction)createProjectBtnClicked:(id)sender;
- (IBAction)createNewProjectDialogBtnClicked:(id)sender;

@end
