//
//  LPOpenedProjectViewController.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPOpenedProjectViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LPLayersManagerViewController.h"
#import "LPSmartLayerManager.h"
#import "LPSmartLayer.h"

@interface LPOpenedProjectViewController ()
@property (strong, nonatomic) NSMutableArray* currSizeConstraints;
@property (strong, nonatomic) NSMutableArray* currCenterConstraints;
@property (strong, nonatomic) UIPopoverController* pc;
@end

@implementation LPOpenedProjectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)keyboardShow:(NSNotification*)aNotification{
    
}

-(void)keyboardClose:(NSNotification*)aNotification{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currMode = LPWADrawing;
    self.workAreaSV.scrollEnabled = NO;
    [[LPSmartLayerManager sharedManager] setRootLayer:self.rootLayer.layer];
    [[LPSmartLayerManager sharedManager] setRootView:self.view];
    [[LPSmartLayerManager sharedManager] addNewLayer];
    currMode = LPWADrawing;
    self.modeSC.selectedSegmentIndex = 0;
    [self.rootLayer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.workAreaSV setTranslatesAutoresizingMaskIntoConstraints:NO];
    BOOL isHeightWouldBeUsedForScale = _currRootLayerHeight > _currRootLayerWidth ? YES : NO;
    float scaleMult;
    if(isHeightWouldBeUsedForScale){
        scaleMult = 600./_currRootLayerHeight;
    }else
        scaleMult = 800./_currRootLayerWidth;
    [self addNewSizeConstraintsWithScale:scaleMult];
    self.rootLayer.layer.borderColor = [UIColor blackColor].CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardClose:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)addCenterConstraints{
    if([self.currCenterConstraints count]){
        [self.view removeConstraints:self.currCenterConstraints];
        [self.currCenterConstraints removeAllObjects];
    }
    NSLayoutConstraint* posConstr = [NSLayoutConstraint constraintWithItem:self.rootLayer
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.workAreaSV
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                  constant:0.0];
    [self.view addConstraint:posConstr];
    [self.currCenterConstraints addObject:posConstr];
    NSLayoutConstraint* posConstr2 = [NSLayoutConstraint constraintWithItem:self.rootLayer
                                             attribute:NSLayoutAttributeCenterY
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self.workAreaSV
                                             attribute:NSLayoutAttributeCenterY
                                            multiplier:1.0
                                              constant:0.0];
    [self.view addConstraint:posConstr2];
    [self.currCenterConstraints addObject:posConstr2];
}

-(void)addNewSizeConstraintsWithScale:(float)nScale{
    if([self.currSizeConstraints count]){
        [self.view removeConstraints:self.currSizeConstraints];
        [self.currSizeConstraints removeAllObjects];\
    }
    self.currScale = nScale;
    self.rootLayer.transform = CGAffineTransformMakeScale(self.currScale, self.currScale);
    self.scaleValueTF.text = [NSString stringWithFormat:@"%.0f%%",self.currScale*100];
    [self.rootLayer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addCenterConstraints];
    
    NSLayoutConstraint* sizeConstr = [NSLayoutConstraint constraintWithItem:self.rootLayer
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.workAreaSV
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:0.0
                                                                   constant:_currRootLayerHeight*self.currScale];
    [self.view addConstraint:sizeConstr];
    [self.currSizeConstraints addObject:sizeConstr];
    NSLayoutConstraint* sizeConstr2 = [NSLayoutConstraint constraintWithItem:self.rootLayer
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.workAreaSV
                                              attribute:NSLayoutAttributeWidth
                                             multiplier:0.0
                                               constant:_currRootLayerWidth*self.currScale];
    [self.view addConstraint:sizeConstr2];
    [self.currSizeConstraints addObject:sizeConstr2];
    self.rootLayer.layer.borderWidth = 1/self.currScale;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeProject:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)showLayersManager:(id)sender {
    UIButton* but = (UIButton*)sender;
    LPLayersManagerViewController* lmvc = [[LPLayersManagerViewController alloc] initWithNibName:@"LPLayersManagerViewController" bundle:nil];
    self.pc = [[UIPopoverController alloc] initWithContentViewController:lmvc];
    [self.pc presentPopoverFromRect:but.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (IBAction)modeChanged:(id)sender {
    //DRAWING
    if(self.modeSC.selectedSegmentIndex == 0){
        self.workAreaSV.scrollEnabled = NO;
        currMode = LPWADrawing;
    }
    //TRANSFORMING
    if(self.modeSC.selectedSegmentIndex == 1){
        self.workAreaSV.scrollEnabled = YES;
        currMode = LPWATransforming;
    }
    //LAYER
    if(self.modeSC.selectedSegmentIndex == 2){
        self.workAreaSV.scrollEnabled = NO;
        currMode = LPWALayer;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([@"" isEqualToString:string])
        return true;
    if(textField == self.scaleValueTF){
        NSScanner *sc = [NSScanner scannerWithString: string];
        NSCharacterSet* allUnaccepted = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789%%"] invertedSet];
        if([sc scanCharactersFromSet:allUnaccepted intoString:&string])
            return false;
        if ([textField.text length]>0 && [textField.text characterAtIndex:[textField.text length]-1] == '%') {
            return false;
        }
        NSString* actValue = [NSString stringWithFormat:@"%@%@",textField.text,string];
        NSRange lastPerc = [actValue rangeOfString:@"%" options:NSBackwardsSearch];
        if(lastPerc.location != NSNotFound)
            actValue = [actValue stringByReplacingCharactersInRange:lastPerc
                                                    withString:@""];
        if([actValue intValue]<1){
            [textField setText:@"1%"];
            return false;
        }
        if([actValue intValue]>30000){
            [textField setText:@"1000%"];
            return false;
        }
    }
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == self.scaleValueTF){
        NSString* actValue = [NSString stringWithString:textField.text];
        NSRange lastPerc = [actValue rangeOfString:@"%" options:NSBackwardsSearch];
        if(lastPerc.location != NSNotFound)
            actValue = [actValue stringByReplacingCharactersInRange:lastPerc
                                                         withString:@""];
        [self addNewSizeConstraintsWithScale:[actValue intValue]/100.];

    }
}

@end
