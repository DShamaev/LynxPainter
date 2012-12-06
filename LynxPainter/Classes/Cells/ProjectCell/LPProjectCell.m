//
//  LPProjectCell.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 06.12.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPProjectCell.h"
#import "LPFileManager.h"
#import "LPLayerData.h"
#import "LPFileInfo.h"
#import <QuartzCore/QuartzCore.h>

@implementation LPProjectCell

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

- (IBAction)projectDeleteBtnClicked:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(deleteFileWithIndex:)]){
        [self.delegate deleteFileWithIndex:self.idx];
    }
}

- (void)fillCellWithFile:(LPFileInfo*)file{
    NSArray* layers = [[LPFileManager sharedManager] readLayersFromProjectFile:file];
    CALayer* mLayer = [CALayer layer];
    for(int i=0;i<[layers count];i++){
        LPLayerData* ld = [layers objectAtIndex:i];
        CALayer* imageLayer = [CALayer layer];
        imageLayer.contents = (id)[UIImage imageWithData:ld.lData].CGImage;
        imageLayer.frame = self.projectPreviewImage.bounds;
        [mLayer addSublayer:imageLayer];
    }
    
    UIGraphicsBeginImageContext(self.projectPreviewImage.bounds.size);
    [mLayer renderInContext:UIGraphicsGetCurrentContext()];
    self.projectPreviewImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.projectPreviewImage.layer.borderColor = [UIColor colorWithRed:162/255. green:145/255. blue:165/255. alpha:1.0].CGColor;
    self.projectPreviewImage.layer.borderWidth = 1;
    
    [self.projectNameLabel setText:file.fiName];
}
@end
