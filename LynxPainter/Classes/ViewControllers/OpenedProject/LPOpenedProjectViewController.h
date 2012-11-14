//
//  LPOpenedProjectViewController.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPWorkAreaView;

typedef enum {
    LPWATransforming,
    LPWADrawing,
    LPWALayer
} LPWAMode;

@interface LPOpenedProjectViewController : UIViewController<UITextFieldDelegate>{
    LPWAMode currMode;
}
@property (strong, nonatomic) UIPopoverController* pc;
@property (strong, nonatomic) IBOutlet LPWorkAreaView *rootLayer;
@property (nonatomic) float currScale;
@property (nonatomic) int currRootLayerWidth;
@property (nonatomic) int currRootLayerHeight;
@property (strong, nonatomic) IBOutlet UITextField *scaleValueTF;
@property (strong, nonatomic) IBOutlet UIScrollView *workAreaSV;
@property (strong, nonatomic) IBOutlet UISegmentedControl *modeSC;
- (IBAction)closeProject:(id)sender;
- (IBAction)showLayersManager:(id)sender;
- (IBAction)modeChanged:(id)sender;
- (IBAction)showDrawingManager:(id)sender;
- (IBAction)undoBtnClicked:(id)sender;

-(void)saveProjectAsJPEGImage:(NSString*)filename;
-(void)saveProjectAsPNGImage:(NSString*)filename;
-(void)saveImageAsLProjectFile:(NSString*)filename;

@end
