//
//  LPHomeViewController.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 03.12.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPHomeViewController.h"
#import "LPGalleryViewController.h"
#import "LPFileManager.h"

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
    self.recentProjectsArray = [NSMutableArray array];
    self.navigationController.navigationBarHidden = YES;
    
    UIView *fakeFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.recentProjectsTable.tableFooterView = fakeFooterView;
    [self.recentProjectsTable registerClass:[LPProjectCell class] forCellReuseIdentifier:@"projectCell"];
    [self.recentProjectsTable registerNib:[UINib nibWithNibName:@"LPProjectCell" bundle:nil] forCellReuseIdentifier:@"projectCell"];
    
    self.recentProjectsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.recentProjectsTable.separatorColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateRecentFiles];
}

-(void)updateRecentFiles{
    self.recentProjectsArray = [[LPFileManager sharedManager] receiveRecentProjectsFilesList];
    [self.recentProjectsTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createProjectFromHome:(id)sender {
    LPGalleryViewController* galVC = [[LPGalleryViewController alloc] initWithNibName:@"LPGalleryViewController" bundle:nil];    
    [self.navigationController pushViewController:galVC animated:YES];
    galVC.createDialogView.hidden = NO;
}

- (IBAction)openExistedFile:(id)sender {
    [self openGallery];
}

- (void)openGallery{
    if(!self.galVC)
        self.galVC = [[LPGalleryViewController alloc] initWithNibName:@"LPGalleryViewController" bundle:nil];
    [self.navigationController pushViewController:self.galVC animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.galVC)
        self.galVC = [[LPGalleryViewController alloc] initWithNibName:@"LPGalleryViewController" bundle:nil];
    LPFileInfo* fi = [self.recentProjectsArray objectAtIndex:indexPath.row];
    self.galVC.of = fi;
    [self openGallery];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.recentProjectsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPProjectCell* cell =(LPProjectCell*) [tableView dequeueReusableCellWithIdentifier:@"projectCell"];
    LPFileInfo* fi = [self.recentProjectsArray objectAtIndex:indexPath.row];
    [cell fillCellWithFile:fi];
    cell.delegate = self;
    cell.idx = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

#pragma mark - LPProjectCellDelegate

- (void)deleteFileWithIndex:(int)idx{
    [[LPFileManager sharedManager] deleteFileWithInfo:[self.recentProjectsArray objectAtIndex:idx] withType:YES];
    [self updateRecentFiles];
}

@end
