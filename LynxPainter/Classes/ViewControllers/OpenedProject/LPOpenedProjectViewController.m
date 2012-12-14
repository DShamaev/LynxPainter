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
#import "LPCloseProjectDialogViewController.h"
#import "LPDrawingManagerViewController.h"
#import "LPLayersManagerViewController.h"
#import "NSData+YBase64String.h"
#import "TBXML.h"
#import "LPFileInfo.h"
#import "LPImagePickerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LPToolCollCell.h"
#import "LPWorkAreaView.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.toolsCV registerClass:[LPToolCollCell class] forCellWithReuseIdentifier:@"toolCollCell"];
    [self.toolsCV registerNib:[UINib nibWithNibName:@"LPToolCollCell" bundle:nil] forCellWithReuseIdentifier:@"toolCollCell"];
    toolsImageArray = [NSMutableArray arrayWithObjects:@"move_tool.png",@"brush_tool.png",@"rect_tool.png",@"ellipse_tool.png",@"line_tool.png",@"eraser_tool.png",@"scale_tool.png", nil];
    currToolIndex = 1;
    
    self.rootLayer.delegate = self;
    [self hideLayerTansformButtons];
    [self.rootLayer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.workAreaSV setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.workAreaSV.scrollEnabled = NO;
    self.currCenterConstraints = [NSMutableArray array];
    self.currSizeConstraints = [NSMutableArray array];
    [[LPSmartLayerManager sharedManager] setRootLayer:self.rootLayer.layer];
    [[LPSmartLayerManager sharedManager] setRootView:self.rootLayer];
    if (self.openedFile) {
        if(self.openedFileModeIsProject)
            [self loadOpenedProjectFile];
        else
            [self createFromImageFile];
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
    UIPinchGestureRecognizer* pgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.workAreaSV addGestureRecognizer:pgr];
    
    UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tgr.numberOfTapsRequired = 2;
    [self.workAreaSV addGestureRecognizer:tgr];
    // Do any additional setup after loading the view from its nib.
    
    lmvc = [[LPLayersManagerViewController alloc] initWithNibName:@"LPLayersManagerViewController" bundle:nil];
    lmvc.delegate = self;
    lmvc.view.layer.borderWidth = 1;
    lmvc.view.layer.borderColor = [UIColor blackColor].CGColor;
    [lmvc.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addVC:lmvc toView:self.view];
    UIView* lv = lmvc.view;
    lv.hidden = YES;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[lv(360)]|" options:NSLayoutFormatAlignAllRight metrics:nil views:NSDictionaryOfVariableBindings(lv)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[lv(460)]" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(lv)]];
    [self changeVC:lmvc withButton:self.layersButton withState:!lmvc.view.hidden withAnimation:NO];

    dmvc = [[LPDrawingManagerViewController alloc] initWithNibName:@"LPDrawingManagerViewController" bundle:nil];
    dmvc.delegate = self;
    dmvc.view.layer.borderWidth = 1;
    dmvc.view.layer.borderColor = [UIColor blackColor].CGColor;
    [dmvc.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addVC:dmvc toView:self.view];
    lv = dmvc.view;
    lv.hidden = YES;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[lv(320)]|" options:NSLayoutFormatAlignAllRight metrics:nil views:NSDictionaryOfVariableBindings(lv)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-500-[lv(360)]" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(lv)]];
    [self changeVC:dmvc withButton:self.toolsButton withState:!dmvc.view.hidden withAnimation:NO];
}

- (void)createFromImageFile{
    _currRootLayerWidth = 1;
    _currRootLayerHeight = 1;
    NSArray *homeDomains = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [homeDomains objectAtIndex:0];
    //NSLog(@"%@",[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self.openedFile.fiName]]);
    UIImage* img = [UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:self.openedFile.fiName]];
    if (img) {
        _currRootLayerWidth = img.size.width;
        _currRootLayerHeight = img.size.height;
        
    }
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
        if(self.openedFileModeIsProject)
            [[LPSmartLayerManager sharedManager] readProjectFile:self.openedFile];
        else
            [[LPSmartLayerManager sharedManager] readImageFile:self.openedFile];
    }else{
        LPSmartLayer* nl = [[LPSmartLayerManager sharedManager] addNewLayer];
        [[LPSmartLayerManager sharedManager] setCurrLayer:nl];
    }
}

-(void)addNewSizeConstraintsWithScale:(float)nScale{
    if([self.currSizeConstraints count]){
        [self.workAreaSV removeConstraints:self.currSizeConstraints];
        [self.currSizeConstraints removeAllObjects];
    }
    self.currScale = nScale;
    self.scaleView.hidden = (self.currScale >= 1.00 && self.currScale < 1.01)  ? YES : NO;
    if(!self.scaleView.hidden)
        self.scaleLabel.text = [NSString stringWithFormat:@"%.0f%%",self.currScale*100];
    self.rootLayer.transform = CGAffineTransformMakeScale(self.currScale, self.currScale);
    
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
    if (lmvc.view.hidden) {
        [lmvc createImagesForLayers];
    }
    [self changeVC:lmvc withButton:self.layersButton withState:lmvc.view.hidden withAnimation:YES];
    [self changeVC:dmvc withButton:self.toolsButton withState:NO withAnimation:YES];
}

- (IBAction)showDrawingManager:(id)sender {
    [self changeVC:dmvc withButton:self.toolsButton withState:dmvc.view.hidden withAnimation:YES];
    [self changeVC:lmvc withButton:self.layersButton withState:NO withAnimation:YES];
}

- (IBAction)undoBtnClicked:(id)sender {
    [[LPSmartLayerManager sharedManager] undo];
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
    UIPinchGestureRecognizer* recognizer = (UIPinchGestureRecognizer*)sender;
    if(!self.rootLayer.isDrawable && !self.rootLayer.isDraggable){        
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
    if(!self.rootLayer.isDrawable && self.rootLayer.isDraggable){
        [self.rootLayer addScaleTransform:recognizer.scale];
    }
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender {
    [LPSmartLayerManager sharedManager].currScale = 1.;
    [self addNewSizeConstraintsWithScale:1.];
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

- (void)changeVC:(UIViewController*)vc withButton:(UIButton*)btn withState:(BOOL)vcVisibility withAnimation:(BOOL)animated{
    if(vcVisibility)
        vc.view.hidden = NO;
    
    void (^visibilityChanges)(void) = ^{
        if(btn)
            btn.transform = vcVisibility ? CGAffineTransformMakeTranslation(-vc.view.bounds.size.width*2, 0) : CGAffineTransformMakeTranslation(0, 0);
        vc.view.transform = vcVisibility ? CGAffineTransformMakeTranslation(0, 0) : CGAffineTransformMakeTranslation(vc.view.bounds.size.width, 0);
    };
    void (^completionChanges)(BOOL) = ^(BOOL comp){
        vc.view.hidden = vcVisibility ? NO : YES;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.35 animations:visibilityChanges completion:completionChanges];
    } else {
        visibilityChanges();
        completionChanges(YES);
    }
    
}

- (void)addVC:(UIViewController*)vc toView:(UIView*)parentView{
    [self addChildViewController:vc];
    [parentView addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}

- (void)removeVC:(UIViewController*)vc fromView:(UIView*)parentView{
    [vc willMoveToParentViewController:nil];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
}

#pragma mark -

-(void)closeAllTabs{
    [self changeVC:dmvc withButton:self.toolsButton withState:NO withAnimation:YES];
    [self changeVC:lmvc withButton:self.layersButton withState:NO withAnimation:YES];
}

-(void)showLayerTansformButtons{
    self.cancelLayerTransformButton.hidden = NO;
    self.applyLayerTransformButton.hidden = NO;
}

-(void)hideLayerTansformButtons{
    self.cancelLayerTransformButton.hidden = YES;
    self.applyLayerTransformButton.hidden = YES;
}


- (IBAction)acceptLayerTransformBtnClicked:(id)sender {
    [self.rootLayer acceptTransform];
    [self hideLayerTansformButtons];
}

- (IBAction)cancelLayerTransformBtnClicked:(id)sender {
    [self.rootLayer cancelTransform];
    [self hideLayerTansformButtons];
}

#pragma mark - UICollectionViewDelegate delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(CATransform3DEqualToTransform([LPSmartLayerManager sharedManager].currLayer.transform, CATransform3DIdentity)){
        currToolIndex = indexPath.row;
        self.workAreaSV.scrollEnabled = NO;
        switch (indexPath.row) {
            case 0:
                [LPSmartLayerManager sharedManager].rootView.isDraggable = YES;
                [LPSmartLayerManager sharedManager].rootView.isDrawable = NO;
                [LPSmartLayerManager sharedManager].rootView.currMode = WADNone;
                break;
            case 1:
                [LPSmartLayerManager sharedManager].rootView.isDraggable = NO;
                [LPSmartLayerManager sharedManager].rootView.isDrawable = YES;
                [LPSmartLayerManager sharedManager].rootView.currMode = WADBrush;
                break;
            case 2:
                [LPSmartLayerManager sharedManager].rootView.isDraggable = NO;
                [LPSmartLayerManager sharedManager].rootView.isDrawable = YES;
                [LPSmartLayerManager sharedManager].rootView.currMode = WADRect;
                break;
            case 3:
                [LPSmartLayerManager sharedManager].rootView.isDraggable = NO;
                [LPSmartLayerManager sharedManager].rootView.isDrawable = YES;
                [LPSmartLayerManager sharedManager].rootView.currMode = WADEllipse;
                break;
            case 4:
                [LPSmartLayerManager sharedManager].rootView.isDraggable = NO;
                [LPSmartLayerManager sharedManager].rootView.isDrawable = YES;
                [LPSmartLayerManager sharedManager].rootView.currMode = WADLine;
                break;
            case 5:
                [LPSmartLayerManager sharedManager].rootView.isDraggable = NO;
                [LPSmartLayerManager sharedManager].rootView.isDrawable = YES;
                [LPSmartLayerManager sharedManager].rootView.currMode = WADEraser;
                break;
            case 6:
                self.workAreaSV.scrollEnabled = YES;
                [LPSmartLayerManager sharedManager].rootView.isDraggable = NO;
                [LPSmartLayerManager sharedManager].rootView.isDrawable = NO;
                [LPSmartLayerManager sharedManager].rootView.currMode = WADNone;
                break;
                
            default:
                break;
        }
        [collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LPToolCollCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"toolCollCell" forIndexPath:indexPath];
    [cell.toolImage setImage:[UIImage imageNamed:[toolsImageArray objectAtIndex:indexPath.row]]];
    [cell setSelectedTool:currToolIndex == indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [toolsImageArray count];
}

@end
