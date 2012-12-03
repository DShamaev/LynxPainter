//
//  LPHomeViewController.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 03.12.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPHomeViewController.h"
#import "LPGalleryViewController.h"

@interface LPHomeViewController ()

@end

@implementation LPHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createProjectFromHome:(id)sender {
    LPGalleryViewController* galVC = [[LPGalleryViewController alloc] initWithNibName:@"LPGalleryViewController" bundle:nil];    
    [self.navigationController pushViewController:galVC animated:YES];
    galVC.createDialogView.hidden = NO;
}

- (IBAction)openExistedFile:(id)sender {
    LPGalleryViewController* galVC = [[LPGalleryViewController alloc] initWithNibName:@"LPGalleryViewController" bundle:nil];
    [self.navigationController pushViewController:galVC animated:YES];
}
@end
