//
//  LPOpenedProjectViewController.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLayersManagerViewController.h"
#import "LPWorkAreaView.h"

@class LPWorkAreaView,LPFileInfo,LPLayersManagerViewController,LPDrawingManagerViewController;

@interface LPOpenedProjectViewController : UIViewController<ImagePickerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WorkAreaDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    UIActionSheet* imagePickerActionsSheet;
    LPLayersManagerViewController* lmvc;
    LPDrawingManagerViewController* dmvc;
    NSMutableArray* toolsImageArray;
    int currToolIndex;
    UIActionSheet* menuActionSheet;
}
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (strong, nonatomic) LPFileInfo* openedFile;
@property (strong, nonatomic) UIPopoverController* pc;
@property (strong, nonatomic) IBOutlet LPWorkAreaView *rootLayer;
@property (strong, nonatomic) IBOutlet UICollectionView *toolsCV;
@property (nonatomic) float currScale;
@property (nonatomic) int currRootLayerWidth;
@property (nonatomic) int currRootLayerHeight;
@property (strong, nonatomic) IBOutlet UIScrollView *workAreaSV;
@property (strong, nonatomic) IBOutlet UILabel *scaleLabel;
@property (strong, nonatomic) IBOutlet UIView *scaleView;
@property (strong, nonatomic) IBOutlet UIButton *cancelLayerTransformButton;
@property (strong, nonatomic) IBOutlet UIButton *applyLayerTransformButton;
@property (strong, nonatomic) IBOutlet UIButton *toolsButton;
@property (strong, nonatomic) IBOutlet UIButton *layersButton;
@property (nonatomic) BOOL openedFileModeIsProject;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) NSString* currFileName;
- (IBAction)closeProject:(id)sender;
- (IBAction)showLayersManager:(id)sender;
- (IBAction)showDrawingManager:(id)sender;
- (IBAction)undoBtnClicked:(id)sender;
- (IBAction)acceptLayerTransformBtnClicked:(id)sender;
- (IBAction)cancelLayerTransformBtnClicked:(id)sender;
- (IBAction)openGalleryBtnClicked:(id)sender;
- (IBAction)saveBtnClicked:(id)sender;

-(void)saveProjectAsJPEGImage:(NSString*)filename;
-(void)saveProjectAsPNGImage:(NSString*)filename;
-(void)saveImageAsLProjectFile:(NSString*)filename;

@end
