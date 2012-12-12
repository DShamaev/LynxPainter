//
//  LPLayersManagerViewController.h
//  LynxPainter
//
//  Created by Администратор on 11/5/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLayerCell.h"

@protocol ImagePickerDelegate <NSObject>

@required
-(void)showImagePickerDialog;
@end

@class LPSmartLayerManager;

@interface LPLayersManagerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,LPLayerCellDelegate>{
    BOOL canMoveCells;
}

@property (strong, nonatomic) LPSmartLayerManager *slm;
@property (strong, nonatomic) IBOutlet UITableView *layerTable;
@property (strong, nonatomic) IBOutlet UIButton *changeVisButton;
@property (strong, nonatomic) IBOutlet UISlider *alphaSlider;
@property (strong, nonatomic) IBOutlet UILabel *alphaLevelLabel;
@property (strong, nonatomic) id<ImagePickerDelegate> delegate;
- (IBAction)createNewLayerBtnClicked:(id)sender;
- (IBAction)createCopyLayerBtnClicked:(id)sender;
- (IBAction)removeLayerBtnClicked:(id)sender;
- (IBAction)changeVisBtnClicked:(id)sender;
- (IBAction)changeAlphaValue:(id)sender;
- (IBAction)createIL:(id)sender;
- (void)createImagesForLayers;

@end
