//
//  LPHomeViewController.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPHomeViewController.h"
#import "LPOpenedProjectViewController.h"

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createProjectBtnClicked:(id)sender {
    _createDialogView.hidden = NO;
}

- (IBAction)createNewProjectDialogBtnClicked:(id)sender {
    LPOpenedProjectViewController* projectVC = [[LPOpenedProjectViewController alloc] initWithNibName:@"LPOpenedProjectViewController" bundle:nil];
    projectVC.currRootLayerWidth = 100;
    projectVC.currRootLayerHeight = 300;
    [self.navigationController pushViewController:projectVC animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == self.rlHeightTF || textField == self.rlWidthTF){
        NSScanner *sc = [NSScanner scannerWithString: string];
        NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if([sc scanCharactersFromSet:nonNumbers intoString:&string])
            return false;
        NSString* actValue = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if([actValue intValue]<1){
            [textField setText:@"1"];
            return false;
        }
        if([actValue intValue]>30000){
            [textField setText:@"30000"];
            return false;
        }
    }
    return true;
}

@end
