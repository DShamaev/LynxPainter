//
//  LPHomeViewController.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 03.12.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPGalleryViewController;

@interface LPHomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *recentProjectsTable;
@property (strong,nonatomic) NSArray* recentProjectsArray;
@property (strong,nonatomic) LPGalleryViewController* galVC;
- (IBAction)createProjectFromHome:(id)sender;
- (IBAction)openExistedFile:(id)sender;

@end
