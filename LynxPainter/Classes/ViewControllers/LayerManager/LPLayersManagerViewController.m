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
    self.selectedIndex = 0;
    UIView *fakeFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.slm = [LPSmartLayerManager sharedManager];
    self.layerTable.tableFooterView = fakeFooterView;
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
    [self.slm setCurrLayerWithIndex:[self.slm.layersArray count]-indexPath.row-1];
    self.selectedIndex = indexPath.row;
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
    if(!cell){
        cell = [self objectWithNibName:@"LPLayerCell" withClass:@"LPLayerCell"];
    }
    LPSmartLayer* sl = [self.slm.layersArray objectAtIndex:[self.slm.layersArray count]-indexPath.row-1];
    [cell setLayer:sl];
    if(indexPath.row == self.selectedIndex)
        [cell setSelected:YES];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


- (IBAction)createNewLayerBtnClicked:(id)sender {
    [self.slm addNewLayer];
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
@end
