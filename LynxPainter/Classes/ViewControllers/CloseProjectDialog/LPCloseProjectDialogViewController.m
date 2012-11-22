//
//  LPCloseProjectDialogViewController.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 12.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPCloseProjectDialogViewController.h"
#import "LPOpenedProjectViewController.h"
#import "LPSmartLayerManager.h"
#import "LPHistoryManager.h"

@interface LPCloseProjectDialogViewController ()

@end

@implementation LPCloseProjectDialogViewController

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
    self.contentSizeForViewInPopover = self.view.bounds.size;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBtnClicked:(id)sender {
    [self.delegate.pc dismissPopoverAnimated:YES];
}

- (IBAction)saveBtnClicked:(id)sender {
    //JPEG
    if(self.formatSC.selectedSegmentIndex == 0){
        [self.delegate saveProjectAsJPEGImage:self.cpdFilenameTF.text];
    }
    //PNG
    if(self.formatSC.selectedSegmentIndex == 1){
        [self.delegate saveProjectAsPNGImage:self.cpdFilenameTF.text];
    }
    //PROJECT
    if(self.formatSC.selectedSegmentIndex == 2){
        [self.delegate saveImageAsLProjectFile:self.cpdFilenameTF.text];
    }
    [self.delegate.pc dismissPopoverAnimated:YES];
    [self.delegate.navigationController popToRootViewControllerAnimated:YES];
    [self clearSharedData];
}

- (IBAction)dontsaveBtnClicked:(id)sender {
    [self.delegate.pc dismissPopoverAnimated:YES];
    [self.delegate.navigationController popToRootViewControllerAnimated:YES];
    [self clearSharedData];
}

- (void)clearSharedData{
    [[LPSmartLayerManager sharedManager] clearManagerData];
    [[LPHistoryManager sharedManager] clearHistoryData];
}
@end
