//
//  LPLayersManagerViewController.m
//  LynxPainter
//
//  Created by Администратор on 11/5/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPLayersManagerViewController.h"
#import "LPSmartLayerManager.h"
#import "LPSmartLayer.h"
#import "UIViewController+XIBLoader.h"

@interface LPLayersManagerViewController ()
@property (nonatomic) int selectedIndex;
@property (nonatomic) NSMutableArray* previewImagesArray;
@end

@implementation LPLayersManagerViewController

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
    self.selectedIndex = 0;
    UIView *fakeFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.slm = [LPSmartLayerManager sharedManager];
    self.layerTable.tableFooterView = fakeFooterView;
    [self.layerTable registerClass:[LPLayerCell class] forCellReuseIdentifier:@"layerCell"];
    [self.layerTable registerNib:[UINib nibWithNibName:@"LPLayerCell" bundle:nil] forCellReuseIdentifier:@"layerCell"];
    canMoveCells = NO;
    UILongPressGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLP:)];
    [self.view addGestureRecognizer:lpgr];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createImagesForLayers{
    self.previewImagesArray = [NSMutableArray array];
    LPSmartLayer* sl;
    int count = [[LPSmartLayerManager sharedManager].layersArray count];
    for (int i=0; i<count; i++) {
        sl = [[LPSmartLayerManager sharedManager].layersArray objectAtIndex:i];
        UIGraphicsBeginImageContext([LPSmartLayerManager sharedManager].rootLayer.bounds.size);
        float opac = sl.opacity;
        BOOL vis = sl.hidden;
        sl.hidden = NO;
        sl.opacity = 1.0;
        [sl renderInContext:UIGraphicsGetCurrentContext()];
        sl.opacity = opac;
        sl.hidden = vis;
        [self.previewImagesArray addObject:UIGraphicsGetImageFromCurrentImageContext()];
        UIGraphicsEndImageContext();
    }
    [self.layerTable reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(CATransform3DEqualToTransform(self.slm.currLayer.transform, CATransform3DIdentity))
       [self selectLayerWithIndexPath:indexPath];
    [self.layerTable reloadData];
}

-(void)selectLayerWithIndexPath:(NSIndexPath*)indexPath{
    [self.slm setCurrLayerWithIndex:[self.slm.layersArray count]-indexPath.row-1];
    self.selectedIndex = indexPath.row;
    [self.alphaSlider setValue:self.slm.currLayer.opacity];
    [self.alphaLevelLabel setText:[NSString stringWithFormat:@"%d%%",(int)(self.slm.currLayer.opacity*100)]];
    [self.changeVisButton setTitle:self.slm.currLayer.hidden ? @"X" : @"V" forState:UIControlStateNormal];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.slm.layersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPLayerCell* cell =(LPLayerCell*) [tableView dequeueReusableCellWithIdentifier:@"layerCell"];
    LPSmartLayer* sl = [self.slm.layersArray objectAtIndex:[self.slm.layersArray count]-indexPath.row-1];
    [cell setLayer:sl];
    [cell fillLayerPreview:[self.previewImagesArray objectAtIndex:[self.slm.layersArray count]-indexPath.row-1]];
    if(indexPath.row == self.selectedIndex){
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            [self selectLayerWithIndexPath:indexPath];
    }
    cell.delegate = self;
    cell.idx = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return canMoveCells;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    canMoveCells = NO;
    self.layerTable.editing = NO;
    [self.slm moveLayerFromIndex:[self.slm.layersArray count] - sourceIndexPath.row-1 ToIndex:[self.slm.layersArray count] - destinationIndexPath.row-1];
    [self createImagesForLayers];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (IBAction)createNewLayerBtnClicked:(id)sender {
    [self.slm addNewLayer];
    [self createImagesForLayers];
    [self.alphaLevelLabel setText:@"100%"];
}

- (IBAction)createCopyLayerBtnClicked:(id)sender {
    [self.slm addNewCopyLayer];
    [self createImagesForLayers];
    [self.alphaLevelLabel setText:@"100%"];
}

- (IBAction)removeLayerBtnClicked:(id)sender {
    [self.slm removeLayer];
    [self createImagesForLayers];
    self.selectedIndex = [self.slm.layersArray count]>0 ? [self.slm.layersArray count]-1 : -1;
}

- (IBAction)changeVisBtnClicked:(id)sender {
    if(self.slm.currLayer){
        [self.slm setCurrLayerVisibility:self.slm.currLayer.hidden];
        [self.changeVisButton setTitle:self.slm.currLayer.hidden ? @"X" : @"V" forState:UIControlStateNormal];
        [self.layerTable reloadData];
    }
}

- (IBAction)changeAlphaValue:(id)sender {
    if(self.slm.currLayer){
        [self.slm setCurrLayerAlpha:self.alphaSlider.value];
        [self.alphaLevelLabel setText:[NSString stringWithFormat:@"%d%%",(int)(self.slm.currLayer.opacity*100)]];
    }
}

- (IBAction)createIL:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(showImagePickerDialog)])
       [self.delegate showImagePickerDialog];
}

- (IBAction)handleLP:(UILongPressGestureRecognizer *)sender {
    canMoveCells = YES;
    self.layerTable.editing = YES;
    [self.layerTable reloadData];
}

#pragma mark - LPProjectCellDelegate

- (void)changeLayerVisibilityWithIndex:(int)idx andValue:(BOOL)vis{
    [[LPSmartLayerManager sharedManager] setLayerWithIndex:[self.slm.layersArray count]-idx-1 withVisibility:vis];
    [self.layerTable reloadData];
}

@end
