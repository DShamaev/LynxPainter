//
//  LPDrawingManagerViewController.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 11/13/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPDrawingManagerViewController.h"
#import "LPOpenedProjectViewController.h"
#import "LPSmartLayerManager.h"
#import "LPSmartLayer.h"
#import "LPWorkAreaView.h"

@interface LPDrawingManagerViewController ()

@end

@implementation LPDrawingManagerViewController

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
    self.brsizeTF.text = [NSString stringWithFormat:@"%d",[LPSmartLayerManager sharedManager].currLayer.smLineWidth];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)redColorBtn:(id)sender {
    if ([LPSmartLayerManager sharedManager].currLayer.smColor != [UIColor redColor]) {
        [LPSmartLayerManager sharedManager].currLayer.smColor = [UIColor redColor];
        [self.delegate.rootLayer needNewSubPathPath];
    }
}

- (IBAction)blueColorBtn:(id)sender {
    if ([LPSmartLayerManager sharedManager].currLayer.smColor != [UIColor blueColor]) {
        [LPSmartLayerManager sharedManager].currLayer.smColor = [UIColor blueColor];
        [self.delegate.rootLayer needNewSubPathPath];
    }
}

- (IBAction)greenColorBtn:(id)sender {
}

- (IBAction)yellowColorBtn:(id)sender {
}

- (IBAction)blackColorBtn:(id)sender {
    if ([LPSmartLayerManager sharedManager].currLayer.smColor != [UIColor blackColor]) {
        [LPSmartLayerManager sharedManager].currLayer.smColor = [UIColor blackColor];
        [self.delegate.rootLayer needNewSubPathPath];
    }
}

- (IBAction)WhiteColorBtn:(id)sender {
    if ([LPSmartLayerManager sharedManager].currLayer.smColor != [UIColor whiteColor]) {
        [LPSmartLayerManager sharedManager].currLayer.smColor = [UIColor whiteColor];
        [self.delegate.rootLayer needNewSubPathPath];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == self.brsizeTF){
        NSScanner *sc = [NSScanner scannerWithString: string];
        NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if([sc scanCharactersFromSet:nonNumbers intoString:&string])
            return false;
        NSString* actValue = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if([actValue intValue]<1){
            [textField setText:@"1"];
            return false;
        }
        if([actValue intValue]>200){
            [textField setText:@"200"];
            return false;
        }
    }
    return true;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if(textField == self.brsizeTF){
        NSLog(@"%d and %d",(int)([textField.text floatValue]/[LPSmartLayerManager sharedManager].currScale),[LPSmartLayerManager sharedManager].currLayer.smLineWidth);
        if ((int)([textField.text floatValue]/[LPSmartLayerManager sharedManager].currScale) != [LPSmartLayerManager sharedManager].currLayer.smLineWidth) {
            [LPSmartLayerManager sharedManager].currLayer.smLineWidth = [textField.text floatValue]/self.delegate.currScale;
            [self.delegate.rootLayer needNewSubPathPath];
        }       
    }
    return false;
}
@end
