//
//  LPImagePickerViewController.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 11/27/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPImagePickerViewController.h"

@interface LPImagePickerViewController ()

@end

@implementation LPImagePickerViewController

- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
@end
