//
//  LPLayerCell.h
//  LynxPainter
//
//  Created by Администратор on 11/5/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPSmartLayer;

@interface LPLayerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *smLayerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *smVisibilityLabel;
@property (strong, nonatomic) IBOutlet UIImageView *smLayerPreview;

- (void)setLayer:(LPSmartLayer*)layer;
- (void)fillLayerPreview:(UIImage*)image;
@end
