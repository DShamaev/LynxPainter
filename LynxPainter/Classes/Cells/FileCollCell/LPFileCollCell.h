//
//  LPFileCollCell.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 11/14/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPFileCollCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *fileImageView;
@property (strong, nonatomic) IBOutlet UILabel *fileNameLabel;
- (void)fillCellWithName:(NSString*)name andImage:(UIImage*)image;
- (IBAction)deleteFile:(id)sender;
@end
