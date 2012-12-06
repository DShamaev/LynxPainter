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

- (IBAction)changeVisBtnClicked:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(changeLayerVisibilityWithIndex:andValue:)]){
        [self.delegate changeLayerVisibilityWithIndex:self.idx andValue:[self.smVisibilityButton.titleLabel.text isEqualToString:@"X"] ? YES : NO];
    }
}

- (void)setLayer:(LPSmartLayer*)layer{
    [self.smLayerNameLabel setText:layer.smName];
    if(layer.hidden){
        [self.smVisibilityButton setTitle:@"X" forState:UIControlStateNormal];
    }else{
        [self.smVisibilityButton setTitle:@"V" forState:UIControlStateNormal];
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
