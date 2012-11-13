//
//  LPHomeViewController.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPHomeViewController : UIViewController<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UIView *createDialogView;
@property (strong, nonatomic) IBOutlet UITextField *rlWidthTF;
@property (strong, nonatomic) IBOutlet UITextField *rlHeightTF;
@property (strong, nonatomic) IBOutlet UICollectionView *fileCollView;
- (IBAction)createNewProjectDialogBtnClicked:(id)sender;
- (IBAction)closeNewProjectDialogBtnClicked:(id)sender;

@end
