//
//  LPFileCollCell.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 11/14/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPFileCollCell.h"

@implementation LPFileCollCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)fillCellWithName:(NSString*)name andImage:(UIImage*)image{
    if(image)
        [self.fileImageView setImage:image];
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
