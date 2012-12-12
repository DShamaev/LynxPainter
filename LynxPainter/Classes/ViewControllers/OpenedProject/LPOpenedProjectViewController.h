//
//  LPOpenedProjectViewController.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLayersManagerViewController.h"

@class LPWorkAreaView,LPFileInfo,LPLayersManagerViewController,LPDrawingManagerViewController;

typedef enum {
    LPWATransforming,
    LPWADrawing,
    LPWALayer
} LPWAMode;

@interface LPOpenedProjectViewController : UIViewController<UITextFieldDelegate,ImagePickerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    LPWAMode currMode;
    UIActionSheet* imagePickerActionsSheet;
    LPLayersManagerViewController* lmvc;
    LPDrawingManagerViewController* dmvc;
}
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (strong, nonatomic) LPFileInfo* openedFile;
@property (strong, nonatomic) UIPopoverController* pc;
@property (strong, nonatomic) IBOutlet LPWorkAreaView *rootLayer;
@property (nonatomic) float currScale;
@property (nonatomic) int currRootLayerWidth;
@property (nonatomic) int currRootLayerHeight;
@property (strong, nonatomic) IBOutlet UITextField *scaleValueTF;
@property (strong, nonatomic) IBOutlet UIScrollView *workAreaSV;
@property (strong, nonatomic) IBOutlet UISegmentedControl *modeSC;
@property (strong, nonatomic) IBOutlet UILabel *scaleLabel;
@property (strong, nonatomic) IBOutlet UIView *scaleView;
@property (strong, nonatomic) IBOutlet UIButton *cancelLayerTransformButton;
@property (strong, nonatomic) IBOutlet UIButton *applyLayerTransformButton;
@property (strong, nonatomic) IBOutlet UIButton *toolsButton;
@property (strong, nonatomic) IBOutlet UIButton *layersButton;
@property (nonatomic) BOOL openedFileModeIsProject;
- (IBAction)closeProject:(id)sender;
- (IBAction)showLayersManager:(id)sender;
- (IBAction)modeChanged:(id)sender;
- (IBAction)showDrawingManager:(id)sender;
- (IBAction)undoBtnClicked:(id)sender;

-(void)saveProjectAsJPEGImage:(NSString*)filename;
-(void)saveProjectAsPNGImage:(NSString*)filename;
-(void)saveImageAsLProjectFile:(NSString*)filename;

@end
