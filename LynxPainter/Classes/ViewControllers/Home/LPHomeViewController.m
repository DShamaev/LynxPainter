//
//  LPHomeViewController.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPHomeViewController.h"
#import "LPOpenedProjectViewController.h"
#import "LPFileCollCell.h"
#import "LPFileManager.h"
#import "LPFileInfo.h"

@interface LPHomeViewController ()
@property (nonatomic,retain) NSMutableArray* fileSectionArray;
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
    self.navigationController.navigationBarHidden = YES;
    [self.fileCollView registerClass:[LPFileCollCell class] forCellWithReuseIdentifier:@"fileCollCell"];
    [self.fileCollView registerNib:[UINib nibWithNibName:@"LPFileCollCell" bundle:nil] forCellWithReuseIdentifier:@"fileCollCell"];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [self updateFileSectionArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createNewProjectDialogBtnClicked:(id)sender {
    _createDialogView.hidden = YES;
    LPOpenedProjectViewController* projectVC = [[LPOpenedProjectViewController alloc] initWithNibName:@"LPOpenedProjectViewController" bundle:nil];
    projectVC.currRootLayerWidth = [self.rlWidthTF.text intValue];
    projectVC.currRootLayerHeight = [self.rlHeightTF.text intValue];
    [self.navigationController pushViewController:projectVC animated:YES];
}

- (IBAction)closeNewProjectDialogBtnClicked:(id)sender {
    _createDialogView.hidden = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == self.rlHeightTF || textField == self.rlWidthTF){
        NSScanner *sc = [NSScanner scannerWithString: string];
        NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if([sc scanCharactersFromSet:nonNumbers intoString:&string])
            return false;
        NSString* actValue = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if([actValue intValue]<1){
            [textField setText:@"1"];
            return false;
        }
        if([actValue intValue]>30000){
            [textField setText:@"30000"];
            return false;
        }
    }
    return true;
}

- (void)updateFileSectionArray{
    if(!self.fileSectionArray)
        self.fileSectionArray = [NSMutableArray array];
    else
        [self.fileSectionArray removeAllObjects];
    NSMutableArray* projectFilesArray = [NSMutableArray array];
    LPFileInfo* npFile = [[LPFileInfo alloc] init];
    [npFile fillWithName:@"Create Project" withURL:@""];
    [projectFilesArray addObject:npFile];
    [projectFilesArray addObjectsFromArray:[[LPFileManager sharedManager] receiveProjectsFilesList]];
    [self.fileSectionArray addObject:projectFilesArray];
    [self.fileSectionArray addObject:[[LPFileManager sharedManager] receiveImagesFilesList]];
}

#pragma mark - UICollectionViewDelegateFlowLayout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 100);
}

#pragma mark - UICollectionViewDelegate delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        _createDialogView.hidden = NO;
    }else{
        NSMutableArray* ca = [self.fileSectionArray objectAtIndex:indexPath.section];
        LPFileInfo* fi = [ca objectAtIndex:indexPath.row];
    }
}

#pragma mark - UICollectionViewDataSource delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LPFileCollCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fileCollCell" forIndexPath:indexPath];
    NSMutableArray* ca = [self.fileSectionArray objectAtIndex:indexPath.section];
    LPFileInfo* fi = [ca objectAtIndex:indexPath.row];
    [cell fillCellWithName:fi.fiName andImage:[UIImage imageWithContentsOfFile:fi.fiURL]];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.fileSectionArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSMutableArray* sa = [self.fileSectionArray objectAtIndex:section];
    return [sa count];
}

@end
