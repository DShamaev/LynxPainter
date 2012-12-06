//
//  LPProjectCell.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 06.12.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPFileInfo;

@interface LPProjectCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *projectPreviewImage;
@property (strong, nonatomic) IBOutlet UILabel *projectNameLabel;
- (IBAction)projectDeleteBtnClicked:(id)sender;
- (void)fillCellWithFile:(LPFileInfo*)file;

@end
