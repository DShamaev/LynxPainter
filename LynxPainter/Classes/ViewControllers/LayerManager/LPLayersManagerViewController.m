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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LPSmartLayer* sl = [self.slm.layersArray objectAtIndex:indexPath.row];
    [self.slm setCurrLayerWithIndex:indexPath.row];
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
    LPSmartLayer* sl = [self.slm.layersArray objectAtIndex:indexPath.row];
    [cell setLayer:sl];
    return cell;
}

@end
