//
//  LPHomeViewController.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 01.11.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPGalleryViewController.h"
#import "LPOpenedProjectViewController.h"
#import "LPFileCollHeaderCell.h"
#import "LPFileManager.h"
#import "LPFileInfo.h"
#import "TBXML.h"

@interface LPGalleryViewController ()
@property (nonatomic,retain) NSMutableArray* fileSectionArray;
@property (nonatomic,retain) NSMutableArray* fileSectionNamesArray;
@end

@implementation LPGalleryViewController

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
    hasImages = NO;
    [self.fileCollView registerClass:[LPFileCollCell class] forCellWithReuseIdentifier:@"fileCollCell"];
    [self.fileCollView registerNib:[UINib nibWithNibName:@"LPFileCollCell" bundle:nil] forCellWithReuseIdentifier:@"fileCollCell"];
    [self.fileCollView registerClass:[LPFileCollHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"fileCollHeaderCell"];
    [self.fileCollView registerNib:[UINib nibWithNibName:@"LPFileCollHeaderCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"fileCollHeaderCell"];
    
    self.fileSectionNamesArray = [NSMutableArray arrayWithObjects:@"Projects",@"Images", nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    if(self.of)
        [self openProject:self.of];
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
        NSString* actValue = actValue = [NSString stringWithFormat:@"%@%@",textField.text,string];
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

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == self.rlHeightTF || textField == self.rlWidthTF){
        if([@"" isEqualToString:textField.text])
            textField.text = @"1";
    }
}

- (void)updateFileSectionArray{
    if(!self.fileSectionArray)
        self.fileSectionArray = [NSMutableArray array];
    else
        [self.fileSectionArray removeAllObjects];
    NSMutableArray* projectFilesArray = [NSMutableArray array];
    LPFileInfo* npFile = [[LPFileInfo alloc] init];
    [npFile fillWithName:@"Create" withURL:@""];
    [projectFilesArray addObject:npFile];
    [projectFilesArray addObjectsFromArray:[[LPFileManager sharedManager] receiveProjectsFilesList]];
    [self.fileSectionArray addObject:projectFilesArray];
    NSArray* imArray = [[LPFileManager sharedManager] receiveImagesFilesList];
    hasImages = [imArray count] > 0 ? YES : NO;
    [self.fileSectionArray addObject:imArray];
    [self.fileCollView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 125);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.bounds.size.width, 50);
}

#pragma mark - UICollectionViewDelegate delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        _createDialogView.hidden = NO;
    }else{
        NSMutableArray* ca = [self.fileSectionArray objectAtIndex:indexPath.section];
        LPFileInfo* fi = [ca objectAtIndex:indexPath.row];
        if(indexPath.section == 0){
            [self openProject:fi withMode:YES];
        }else{
            [self openProject:fi withMode:NO];
        }
    }
}

- (void)openProject:(LPFileInfo*)fi withMode:(BOOL)isProject{
    LPOpenedProjectViewController* projectVC = [[LPOpenedProjectViewController alloc] initWithNibName:@"LPOpenedProjectViewController" bundle:nil];
    projectVC.openedFile = fi;
    projectVC.openedFileModeIsProject = isProject;
    [self.navigationController pushViewController:projectVC animated:YES];
}

#pragma mark - UICollectionViewDataSource delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LPFileCollCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fileCollCell" forIndexPath:indexPath];
    NSMutableArray* ca = [self.fileSectionArray objectAtIndex:indexPath.section];
    LPFileInfo* fi = [ca objectAtIndex:indexPath.row];
    [cell fillCellWithName:fi.fiName andImage:[UIImage imageWithContentsOfFile:fi.fiURL]];
    cell.delegate = self;
    cell.idp = indexPath;
    return cell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    LPFileCollHeaderCell* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"fileCollHeaderCell" forIndexPath:indexPath];
    [view.fileSectionName setText:[self.fileSectionNamesArray objectAtIndex:indexPath.section]];
    return view;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (!hasImages) {
        return 1;
    }
    return [self.fileSectionArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSMutableArray* sa = [self.fileSectionArray objectAtIndex:section];
    return [sa count];
}

#pragma mark - LPFileCollCell delegate

- (void)deleteFileWithIndexPath:(NSIndexPath*)idp{
    NSMutableArray* files = [self.fileSectionArray objectAtIndex:idp.section];
    LPFileInfo* fi = [files objectAtIndex:idp.row];
    [[LPFileManager sharedManager] deleteFileWithInfo:fi withType:idp.section == 0];
    [self updateFileSectionArray];
}

@end
