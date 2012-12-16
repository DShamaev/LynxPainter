//
//  LPFileCollCell.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 11/14/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LPFileCollCellDelegate <NSObject>

@required
- (void)deleteFileWithIndexPath:(NSIndexPath*)idp;

@end

@interface LPFileCollCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *fileImageView;
@property (strong, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (strong, nonatomic) id<LPFileCollCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath* idp;
@property (strong, nonatomic) IBOutlet UIButton *trashButton;
- (void)fillCellWithName:(NSString*)name andImage:(UIImage*)image withTrashVis:(BOOL)trVis;
- (IBAction)deleteFile:(id)sender;
@end
