//
//  LPLayersManagerViewController.h
//  LynxPainter
//
//  Created by Администратор on 11/5/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPSmartLayerManager;

@interface LPLayersManagerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) LPSmartLayerManager *slm;
@property (strong, nonatomic) IBOutlet UITableView *layerTable;
@property (strong, nonatomic) IBOutlet UIButton *changeVisButton;
@property (strong, nonatomic) IBOutlet UISlider *alphaSlider;
@property (strong, nonatomic) IBOutlet UILabel *alphaLevelLabel;
- (IBAction)createNewLayerBtnClicked:(id)sender;
- (IBAction)moveSelectedLayerUpBtnClicked:(id)sender;
- (IBAction)moveSelectedLayerDownBtnClicked:(id)sender;
- (IBAction)removeLayerBtnClicked:(id)sender;
- (IBAction)changeVisBtnClicked:(id)sender;
- (IBAction)changeAlphaValue:(id)sender;

@end
