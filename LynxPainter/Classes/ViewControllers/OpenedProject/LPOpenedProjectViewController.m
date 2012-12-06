//
//  LPOpenedProjectViewController.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPOpenedProjectViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LPSmartLayerManager.h"
#import "LPSmartLayer.h"
#import "LPWorkAreaView.h"
#import "LPCloseProjectDialogViewController.h"
#import "LPDrawingManagerViewController.h"
#import "NSData+YBase64String.h"
#import "TBXML.h"
#import "LPFileInfo.h"
#import "LPImagePickerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LPOpenedProjectViewController (){
    float tempScale;
}
@property (strong, nonatomic) NSMutableArray* currSizeConstraints;
@property (strong, nonatomic) NSMutableArray* currCenterConstraints;
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
    [self.rootLayer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.workAreaSV setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    currMode = LPWADrawing;
    self.workAreaSV.scrollEnabled = NO;
    self.currCenterConstraints = [NSMutableArray array];
    self.currSizeConstraints = [NSMutableArray array];
    [[LPSmartLayerManager sharedManager] setRootLayer:self.rootLayer.layer];
    [[LPSmartLayerManager sharedManager] setRootView:self.rootLayer];
    currMode = LPWADrawing;
    self.modeSC.selectedSegmentIndex = 0;
    if (self.openedFile) {
        [self loadOpenedProjectFile];
    }
    BOOL isHeightWouldBeUsedForScale = _currRootLayerHeight > _currRootLayerWidth ? YES : NO;
    float scaleMult=1;
    if(isHeightWouldBeUsedForScale){
        scaleMult = 768./_currRootLayerHeight;
    }else
        scaleMult = 1024./_currRootLayerWidth;
    [LPSmartLayerManager sharedManager].currScale = scaleMult;
    //[self addCenterConstraints];
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
    UIPinchGestureRecognizer* pgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.workAreaSV addGestureRecognizer:pgr];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadOpenedProjectFile{
    _currRootLayerWidth = 1;
    _currRootLayerHeight = 1;
    NSError* err = nil;
    NSArray *homeDomains = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [homeDomains objectAtIndex:0];
    NSLog(@"%@",[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Projects/%@",self.openedFile.fiName]]);
    TBXML* pf = [[TBXML alloc] initWithXMLString:[NSString stringWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Projects/%@",self.openedFile.fiName]] encoding:NSUTF8StringEncoding error:&err] error:&err];
    TBXMLElement* root = [pf rootXMLElement];
    if(root){
        TBXMLElement* widthEl = [TBXML childElementNamed:@"LPWidth" parentElement:root];
        if (widthEl) {
            _currRootLayerWidth = [[TBXML textForElement:widthEl] intValue];
        }
        TBXMLElement* heightEl = [TBXML childElementNamed:@"LPHeight" parentElement:root];
        if (widthEl) {
            _currRootLayerHeight = [[TBXML textForElement:heightEl] intValue];
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Project file can't be opened" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    if(self.openedFile){
        [[LPSmartLayerManager sharedManager] readProjectFile:self.openedFile];
    }else{
        LPSmartLayer* nl = [[LPSmartLayerManager sharedManager] addNewLayer];
        [[LPSmartLayerManager sharedManager] setCurrLayer:nl];
    }
}

-(void)addCenterConstraints{
    if([self.currCenterConstraints count]){
        [self.workAreaSV removeConstraints:self.currCenterConstraints];
        [self.currCenterConstraints removeAllObjects];
    }
    NSLayoutConstraint* posConstr = [NSLayoutConstraint constraintWithItem:self.rootLayer
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.workAreaSV
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                  constant:0.0];
    [self.workAreaSV addConstraint:posConstr];
    [self.currCenterConstraints addObject:posConstr];
    NSLayoutConstraint* posConstr2 = [NSLayoutConstraint constraintWithItem:self.rootLayer
                                             attribute:NSLayoutAttributeCenterY
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self.workAreaSV
                                             attribute:NSLayoutAttributeCenterY
                                            multiplier:1.0
                                              constant:0.0];
    [self.workAreaSV addConstraint:posConstr2];
    [self.currCenterConstraints addObject:posConstr2];
}

-(void)addNewSizeConstraintsWithScale:(float)nScale{
    if([self.currSizeConstraints count]){
        [self.workAreaSV removeConstraints:self.currSizeConstraints];
        [self.currSizeConstraints removeAllObjects];
    }
    self.currScale = nScale;
    if(self.currScale != 1){
        
    }
    self.scaleView.hidden = (self.currScale > 1.00 && self.currScale < 1.01)  ? YES : NO;
    self.rootLayer.transform = CGAffineTransformMakeScale(self.currScale, self.currScale);
    self.scaleValueTF.text = [NSString stringWithFormat:@"%.0f%%",self.currScale*100];
    
    NSLayoutConstraint* sizeConstr = [NSLayoutConstraint constraintWithItem:self.rootLayer
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.workAreaSV
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:0.0
                                                                   constant:_currRootLayerHeight*self.currScale];
    [self.workAreaSV addConstraint:sizeConstr];
    [self.currSizeConstraints addObject:sizeConstr];
    NSLayoutConstraint* sizeConstr2 = [NSLayoutConstraint constraintWithItem:self.rootLayer
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.workAreaSV
                                              attribute:NSLayoutAttributeWidth
                                             multiplier:0.0
                                               constant:_currRootLayerWidth*self.currScale];
    [self.workAreaSV addConstraint:sizeConstr2];
    [self.currSizeConstraints addObject:sizeConstr2];
    self.rootLayer.layer.borderWidth = 1/self.currScale;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeProject:(id)sender {
    UIButton* but = (UIButton*)sender;
    LPCloseProjectDialogViewController* cpdvc = [[LPCloseProjectDialogViewController alloc] initWithNibName:@"LPCloseProjectDialogViewController" bundle:nil];
    cpdvc.delegate = self;
    self.pc = [[UIPopoverController alloc] initWithContentViewController:cpdvc];
    [self.pc presentPopoverFromRect:but.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)showLayersManager:(id)sender {
    UIButton* but = (UIButton*)sender;
    LPLayersManagerViewController* lmvc = [[LPLayersManagerViewController alloc] initWithNibName:@"LPLayersManagerViewController" bundle:nil];
    lmvc.delegate = self;
    self.pc = [[UIPopoverController alloc] initWithContentViewController:lmvc];
    [self.pc presentPopoverFromRect:but.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (IBAction)modeChanged:(id)sender {
    //DRAWING
    if(self.modeSC.selectedSegmentIndex == 0){
        self.workAreaSV.scrollEnabled = NO;
        currMode = LPWADrawing;
        self.rootLayer.isDrawable = YES;
        self.rootLayer.isDraggable = NO;
    }
    //TRANSFORMING
    if(self.modeSC.selectedSegmentIndex == 1){
        self.workAreaSV.scrollEnabled = YES;
        currMode = LPWATransforming;
        self.rootLayer.isDrawable = NO;
        self.rootLayer.isDraggable = NO;
    }
    //LAYER
    if(self.modeSC.selectedSegmentIndex == 2){
        self.workAreaSV.scrollEnabled = NO;
        currMode = LPWALayer;
        self.rootLayer.isDrawable = NO;
        self.rootLayer.isDraggable = YES;
    }
}

- (IBAction)showDrawingManager:(id)sender {
    UIButton* but = (UIButton*)sender;
    LPDrawingManagerViewController* dmvc = [[LPDrawingManagerViewController alloc] initWithNibName:@"LPDrawingManagerViewController" bundle:nil];
    dmvc.delegate = self;
    self.pc = [[UIPopoverController alloc] initWithContentViewController:dmvc];
    [self.pc presentPopoverFromRect:but.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (IBAction)undoBtnClicked:(id)sender {
    [[LPSmartLayerManager sharedManager] undo];
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
        [LPSmartLayerManager sharedManager].currScale = [actValue intValue]/100.;
    }
}

-(void)saveProjectAsJPEGImage:(NSString*)filename{
    NSArray *homeDomains = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [homeDomains objectAtIndex:0];
    UIGraphicsBeginImageContext(self.rootLayer.bounds.size);
    [self.rootLayer.layer renderInContext:UIGraphicsGetCurrentContext()];
    NSData* content = UIImageJPEGRepresentation(UIGraphicsGetImageFromCurrentImageContext(), 1.);
    UIGraphicsEndImageContext();
    [content writeToFile:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",filename]] atomically:YES];
}

-(void)saveProjectAsPNGImage:(NSString*)filename{
    NSArray *homeDomains = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [homeDomains objectAtIndex:0];
    UIGraphicsBeginImageContext(self.rootLayer.bounds.size);
    [self.rootLayer.layer renderInContext:UIGraphicsGetCurrentContext()];
    NSData* content = UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext());
    UIGraphicsEndImageContext();
    [content writeToFile:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",filename]] atomically:YES];
}

-(void)saveImageAsLProjectFile:(NSString*)filename{
    NSArray *homeDomains = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [homeDomains objectAtIndex:0];
    LPSmartLayerManager* slm = [LPSmartLayerManager sharedManager];
    NSString *newDir = [documentsDirectory stringByAppendingPathComponent:@"Projects"];
    [[NSFileManager defaultManager] createDirectoryAtPath:newDir withIntermediateDirectories:YES
                                                   attributes:nil error: NULL];
    NSString* fileData = @"<LPFileRoot>";
    fileData=[fileData stringByAppendingFormat:@"<LPWidth>%d</LPWidth>",_currRootLayerWidth];
    fileData=[fileData stringByAppendingFormat:@"<LPHeight>%d</LPHeight>",_currRootLayerHeight];
    if([slm.layersArray count]>0){
        fileData=[fileData stringByAppendingFormat:@"<LPLayersCount>%d</LPLayersCount>",[slm.layersArray count]];
    }
    LPSmartLayer* sl;
    for (int i=0; i<[slm.layersArray count]; i++) {
        fileData=[fileData stringByAppendingString:@"<LPFileLayer>"];
        sl = [slm.layersArray objectAtIndex:i];
        fileData=[fileData stringByAppendingFormat:@"<LPLayerName>%@</LPLayerName>",sl.smName];
        fileData=[fileData stringByAppendingFormat:@"<LPLayerOpacity>%f</LPLayerOpacity>",sl.opacity];
        fileData=[fileData stringByAppendingFormat:@"<LPLayerVisibility>%d</LPLayerVisibility>",!sl.hidden];
        
        UIGraphicsBeginImageContext(self.rootLayer.bounds.size);
        float opac = sl.opacity;
        BOOL vis = sl.hidden;
        sl.hidden = NO;
        sl.opacity = 1.0;
        [sl renderInContext:UIGraphicsGetCurrentContext()];
        NSData* content = UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext());
        fileData=[fileData stringByAppendingFormat:@"<LPLayerData>%@</LPLayerData>",[content base64String]];
        sl.opacity = opac;
        sl.hidden = vis;
        UIGraphicsEndImageContext();
        
        fileData=[fileData stringByAppendingString:@"</LPFileLayer>"];
    }
    fileData=[fileData stringByAppendingString:@"</LPFileRoot>"];
    [fileData writeToFile:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Projects/%@.lpf",filename]] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (IBAction)handlePinch:(UIGestureRecognizer *)sender {
    if(!self.rootLayer.isDrawable && !self.rootLayer.isDraggable){
        UIPinchGestureRecognizer* recognizer = (UIPinchGestureRecognizer*)sender;
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            tempScale = [LPSmartLayerManager sharedManager].currScale;
        } else if (recognizer.state == UIGestureRecognizerStateEnded ||
                   recognizer.state == UIGestureRecognizerStateCancelled ||
                   recognizer.state == UIGestureRecognizerStateFailed)
        {
            float scale= 1;
            if (tempScale*recognizer.scale > 300) {
                scale = 300;
            }else if(tempScale*recognizer.scale<0.01){
                scale = 0.01;
            }else{
                scale = tempScale*recognizer.scale;
            }
            [LPSmartLayerManager sharedManager].currScale = scale;
        }else{
            float scale= 1;
            if (tempScale*recognizer.scale > 300) {
                scale = 300;
            }else if(tempScale*recognizer.scale<0.01){
                scale = 0.01;
            }else{
                scale = tempScale*recognizer.scale;
            }
            [self addNewSizeConstraintsWithScale:scale];
        }
    }
}

- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    if (self.imagePickerPopover && self.imagePickerPopover.isPopoverVisible) {
        return;
    }
    
    UIImagePickerController *imagePicker = [[LPImagePickerViewController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    imagePicker.allowsEditing = YES;
    
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {        
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [self.imagePickerPopover presentPopoverFromRect:CGRectMake(0, 44, 1.0, 1.0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (actionSheet == imagePickerActionsSheet) {
        
         switch (buttonIndex) {
             case 1:
                 if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                     [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                 }
                 break;
             case 2:
                 if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                     [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                 }
                default:
                    break;
            }
    }
}

#pragma mark - ImagePickerDelegate

-(void)showImagePickerDialog{
    if (self.pc && self.pc.isPopoverVisible) {
        [self.pc dismissPopoverAnimated:YES];
    }
    if ((self.imagePickerPopover && self.imagePickerPopover.isPopoverVisible) || (imagePickerActionsSheet && imagePickerActionsSheet.isVisible)) {
        return;
    }
    
    imagePickerActionsSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Import from camera", @"Import from library", nil];
    [imagePickerActionsSheet showInView:self.view];
}

#pragma mark -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [[LPSmartLayerManager sharedManager] addNewImageLayer:pickedImage];
       
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
