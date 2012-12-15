//
//  LPToolCell.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 12/13/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPToolCollCell.h"
#import <QuartzCore/QuartzCore.h> 

@implementation LPToolCollCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelectedTool:(BOOL)selected{
    self.layer.borderWidth = selected ? 2 : 0;
    self.layer.borderColor = [UIColor colorWithRed:149./255 green:140./255 blue:154./255 alpha:1.].CGColor;
}


@end
