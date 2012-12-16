//
//  LPFileCollCell.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 11/14/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPFileCollCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation LPFileCollCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)fillCellWithName:(NSString*)name andImage:(UIImage*)image withTrashVis:(BOOL)trVis{
    if(image){
        [self.fileImageView setImage:image];
    }else
        [self.fileImageView setImage:[UIImage imageNamed:@"proj_icon.png"]];
    self.trashButton.hidden = !trVis;
    self.fileImageView.layer.borderWidth = image!=nil ? 1 : 0;
    self.fileImageView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.fileNameLabel setText:name];
}

- (IBAction)deleteFile:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(deleteFileWithIndexPath:)]){
        [self.delegate deleteFileWithIndexPath:self.idp];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
