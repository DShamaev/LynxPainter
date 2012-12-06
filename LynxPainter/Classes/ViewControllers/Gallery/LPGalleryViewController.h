//
//  LPHomeViewController.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPFileCollCell.h"

@class LPFileInfo;

@interface LPGalleryViewController : UIViewController<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LPFileCollCellDelegate>{
    UIActionSheet* fileActionsSheet;
    BOOL fileActionsMode; // NO - project file; YES - image file;
    BOOL hasImages;
    NSIndexPath* selectedFileIP;
}
@property (strong, nonatomic) IBOutlet UIView *createDialogView;
@property (strong, nonatomic) IBOutlet UITextField *rlWidthTF;
@property (strong, nonatomic) IBOutlet UITextField *rlHeightTF;
@property (strong, nonatomic) IBOutlet UICollectionView *fileCollView;
@property (strong, nonatomic) LPFileInfo* of;
- (IBAction)createNewProjectDialogBtnClicked:(id)sender;
- (IBAction)closeNewProjectDialogBtnClicked:(id)sender;
- (void)openProject:(LPFileInfo*)fi;

@end
