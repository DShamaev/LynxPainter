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
- (IBAction)createNewLayerBtnClicked:(id)sender;
- (IBAction)moveSelectedLayerUpBtnClicked:(id)sender;
- (IBAction)moveSelectedLayerDownBtnClicked:(id)sender;

@end
