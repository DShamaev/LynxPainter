//
//  LPProjectCell.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 06.12.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LPProjectCellDelegate <NSObject>

@required
- (void)deleteFileWithIndex:(int)idx;

@end

@class LPFileInfo;

@interface LPProjectCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *projectPreviewImage;
@property (strong, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (strong, nonatomic) id<LPProjectCellDelegate> delegate;
@property (nonatomic) int idx;
- (IBAction)projectDeleteBtnClicked:(id)sender;
- (void)fillCellWithFile:(LPFileInfo*)file;

@end
