//
//  LPLayerCell.m
//  LynxPainter
//
//  Created by Администратор on 11/5/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPLayerCell.h"
#import "LPSmartLayer.h"

@implementation LPLayerCell

- (void)awakeFromNib{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLayer:(LPSmartLayer*)layer{
    [self.smLayerNameLabel setText:layer.smName];
    if(layer.hidden){
       [self.smVisibilityLabel setText:@"X"];
    }else{
        [self.smVisibilityLabel setText:@"V"];
    }
}

- (void)fillLayerPreview:(UIImage*)image{
    self.smLayerPreview.layer.borderColor = [UIColor blackColor].CGColor;
    self.smLayerPreview.layer.borderWidth = 1;
    if (image != nil) {
        [self.smLayerPreview setImage:image];
    }
}

@end
