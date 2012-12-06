//
//  LPHomeViewController.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 03.12.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPProjectCell.h"

@class LPGalleryViewController;

@interface LPHomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,LPProjectCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *recentProjectsTable;
@property (strong,nonatomic) NSArray* recentProjectsArray;
@property (strong,nonatomic) LPGalleryViewController* galVC;
@property (strong, nonatomic) IBOutlet UILabel *recProjLabel;
- (IBAction)createProjectFromHome:(id)sender;
- (IBAction)openExistedFile:(id)sender;

@end
