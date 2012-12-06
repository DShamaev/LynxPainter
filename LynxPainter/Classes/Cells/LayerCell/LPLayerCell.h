//
//  LPLayerCell.h
//  LynxPainter
//
//  Created by Администратор on 11/5/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LPLayerCellDelegate <NSObject>

@required
- (void)changeLayerVisibilityWithIndex:(int)idx andValue:(BOOL)vis;

@end

@class LPSmartLayer;

@interface LPLayerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *smLayerNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *smVisibilityButton;
@property (strong, nonatomic) IBOutlet UIImageView *smLayerPreview;
@property (strong, nonatomic) id<LPLayerCellDelegate> delegate;
@property (nonatomic) int idx;

- (IBAction)changeVisBtnClicked:(id)sender;
- (void)setLayer:(LPSmartLayer*)layer;
- (void)fillLayerPreview:(UIImage*)image;
@end
