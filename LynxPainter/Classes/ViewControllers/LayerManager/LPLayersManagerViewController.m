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
#import "LPLayerCell.h"
#import "UIViewController+XIBLoader.h"

@interface LPLayersManagerViewController ()
@property (nonatomic) int selectedIndex;
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LPSmartLayer* sl = [self.slm.layersArray objectAtIndex:[self.slm.layersArray count]-indexPath.row-1];
    [self selectLayerWithIndexPath:indexPath];
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
    if(indexPath.row == self.selectedIndex){
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [self selectLayerWithIndexPath:indexPath];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


- (IBAction)createNewLayerBtnClicked:(id)sender {
    [self.slm addNewLayer];
    [self.alphaLevelLabel setText:@"100%"];
    [self.layerTable reloadData];
}

- (IBAction)moveSelectedLayerUpBtnClicked:(id)sender {
    [self.slm moveLayerUp];
    self.selectedIndex-=1;
    [self.layerTable reloadData];
}

- (IBAction)moveSelectedLayerDownBtnClicked:(id)sender {
    [self.slm moveLayerDown];
    self.selectedIndex+=1;
    [self.layerTable reloadData];
}

- (IBAction)removeLayerBtnClicked:(id)sender {
    [self.slm removeLayer];
    self.selectedIndex = [self.slm.layersArray count]>0 ? [self.slm.layersArray count]-1 : -1;
    [self.layerTable reloadData];
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
@end
