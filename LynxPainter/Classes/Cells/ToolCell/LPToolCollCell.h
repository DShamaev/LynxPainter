//
//  LPToolCell.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 12/13/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPToolCollCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *toolImage;
- (void)setSelectedTool:(BOOL)selected;
@end
