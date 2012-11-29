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
    CGFloat hue = 0.0, saturation = 0.0, brightness = 0.0, alpha = 0.0;
    [[LPSmartLayerManager sharedManager].currLayer.smColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    [self.hueLabel setText:[NSString stringWithFormat:@"%d",(int)(hue*360)]];
    self.hueSlider.value =(int)(hue*360);
    [self.saturationLabel setText:[NSString stringWithFormat:@"%d",(int)(saturation*100)]];
    self.saturationSlider.value = (int)(saturation*100);
    [self.valueLabel setText:[NSString stringWithFormat:@"%d",(int)(brightness*100)]];
    self.valueSlider.value = (int)(brightness*100);
    self.contentSizeForViewInPopover = self.view.bounds.size;
    self.brsizeTF.text = [NSString stringWithFormat:@"%d",(int)([LPSmartLayerManager sharedManager].currLayer.smLineWidth*self.delegate.currScale)];
    switch ([LPSmartLayerManager sharedManager].rootView.currMode) {
        case WADBrush:
            self.toolsSC.selectedSegmentIndex=0;
            break;
        case WADRect:
            self.toolsSC.selectedSegmentIndex=1;
            break;
        case WADEllipse:
            self.toolsSC.selectedSegmentIndex=2;
            break;
        case WADLine:
            self.toolsSC.selectedSegmentIndex=3;
            break;
        case WADEraser:
            self.toolsSC.selectedSegmentIndex=4;
            break;
            
        default:
            break;
    }
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
        [self notifyAboutColorChange];
    }
}

- (IBAction)blueColorBtn:(id)sender {
    if ([LPSmartLayerManager sharedManager].currLayer.smColor != [UIColor blueColor]) {
        [LPSmartLayerManager sharedManager].currLayer.smColor = [UIColor blueColor];
        [self notifyAboutColorChange];
    }
}

- (IBAction)greenColorBtn:(id)sender {
    if ([LPSmartLayerManager sharedManager].currLayer.smColor != [UIColor greenColor]) {
        [LPSmartLayerManager sharedManager].currLayer.smColor = [UIColor greenColor];
        [self notifyAboutColorChange];
    }
}

- (IBAction)yellowColorBtn:(id)sender {
    if ([LPSmartLayerManager sharedManager].currLayer.smColor != [UIColor yellowColor]) {
        [LPSmartLayerManager sharedManager].currLayer.smColor = [UIColor yellowColor];
        [self notifyAboutColorChange];
    }
}

- (IBAction)blackColorBtn:(id)sender {
    if ([LPSmartLayerManager sharedManager].currLayer.smColor != [UIColor blackColor]) {
        [LPSmartLayerManager sharedManager].currLayer.smColor = [UIColor blackColor];
        [self notifyAboutColorChange];
    }
}

- (IBAction)WhiteColorBtn:(id)sender {
    if ([LPSmartLayerManager sharedManager].currLayer.smColor != [UIColor whiteColor]) {
        [LPSmartLayerManager sharedManager].currLayer.smColor = [UIColor whiteColor];
        [self notifyAboutColorChange];
    }
}

- (IBAction)hueValueChanged:(id)sender {
    [LPSmartLayerManager sharedManager].currLayer.smColor = [UIColor colorWithHue:self.hueSlider.value/360 saturation:self.saturationSlider.value/100 brightness:self.valueSlider.value/100 alpha:1.0];
    [self notifyAboutColorChange];
}

- (IBAction)saturationValueChanged:(id)sender {
    [LPSmartLayerManager sharedManager].currLayer.smColor = [UIColor colorWithHue:self.hueSlider.value/360 saturation:self.saturationSlider.value/100 brightness:self.valueSlider.value/100 alpha:1.0];
    [self notifyAboutColorChange];
}

- (IBAction)valueValueChanged:(id)sender {
    [LPSmartLayerManager sharedManager].currLayer.smColor = [UIColor colorWithHue:self.hueSlider.value/360 saturation:self.saturationSlider.value/100 brightness:self.valueSlider.value/100 alpha:1.0];
    [self notifyAboutColorChange];
}

- (IBAction)toolChanged:(id)sender {
    if(self.toolsSC.selectedSegmentIndex == 0){
        [LPSmartLayerManager sharedManager].rootView.currMode = WADBrush;        
    }
    if(self.toolsSC.selectedSegmentIndex == 1){
        [LPSmartLayerManager sharedManager].rootView.currMode = WADRect;
    }
    if(self.toolsSC.selectedSegmentIndex == 2){
        [LPSmartLayerManager sharedManager].rootView.currMode = WADEllipse;
    }
    if(self.toolsSC.selectedSegmentIndex == 3){
        [LPSmartLayerManager sharedManager].rootView.currMode = WADLine;
    }
    if(self.toolsSC.selectedSegmentIndex == 4){
        [LPSmartLayerManager sharedManager].rootView.currMode = WADEraser;
    }
}

- (void) notifyAboutColorChange{
    CGFloat hue = 0.0, saturation = 0.0, brightness = 0.0, alpha = 0.0;
    [[LPSmartLayerManager sharedManager].currLayer.smColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    [self.hueLabel setText:[NSString stringWithFormat:@"%d",(int)(hue*360)]];
    [self.saturationLabel setText:[NSString stringWithFormat:@"%d",(int)(saturation*100)]];
    [self.valueLabel setText:[NSString stringWithFormat:@"%d",(int)(brightness*100)]];
    self.hueSlider.value = (int)(hue*360);
    self.saturationSlider.value = (int)(saturation*100);
    self.valueSlider.value = (int)(brightness*100);
    [self.currColorView setBackgroundColor:[LPSmartLayerManager sharedManager].currLayer.smColor];
    //[self.delegate.rootLayer needNewSubPathPath];
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
        if ((int)([textField.text floatValue]/[LPSmartLayerManager sharedManager].currScale) != [LPSmartLayerManager sharedManager].currLayer.smLineWidth) {
            [LPSmartLayerManager sharedManager].currLayer.smLineWidth = [textField.text floatValue]/self.delegate.currScale;
            //[self.delegate.rootLayer needNewSubPathPath];
        }       
    }
    return true;
}
@end
