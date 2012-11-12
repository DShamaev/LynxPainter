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
- (IBAction)redColorBtn:(id)sender;
- (IBAction)blueColorBtn:(id)sender;
- (IBAction)greenColorBtn:(id)sender;
- (IBAction)yellowColorBtn:(id)sender;
- (IBAction)blackColorBtn:(id)sender;
- (IBAction)WhiteColorBtn:(id)sender;

@end
