//
//  LPFileManager.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 11/14/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPFileManager.h"
#import "LPFileInfo.h"
#import "LPLayerData.h"
#import "TBXML.h"
#import "NSString+YBase64toData.h"

@implementation LPFileManager

+ (LPFileManager *)sharedManager {
    static LPFileManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LPFileManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (NSArray*)receiveProjectsFilesList{
    NSArray *homeDomains = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [homeDomains objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Projects"];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:documentsDirectory
                                                      error:nil];
    
    NSMutableArray *arrayOfProjects = [[NSMutableArray alloc] init];
    for (int count = 0; count < files.count; count++) {
        NSString* fileName = [files objectAtIndex:count];
        //if hidden file
        if ([fileName characterAtIndex:0] == '.') {
            continue;
        }
        LPFileInfo* fi = [[LPFileInfo alloc] init];
        [fi fillWithName:[files objectAtIndex:count] withURL:[documentsDirectory stringByAppendingPathComponent:[files objectAtIndex:count]]];
        [arrayOfProjects addObject:fi];
    }
    return arrayOfProjects;
}

- (NSArray*)receiveRecentProjectsFilesList{
    NSArray *homeDomains = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [homeDomains objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Projects"];
    
    NSArray *docFileList = [[NSFileManager defaultManager] subpathsAtPath:documentsDirectory];
    NSEnumerator *docEnumerator = [docFileList objectEnumerator];
    NSString *docFilePath;
    NSMutableArray* filesArray = [NSMutableArray array];
    
    while ((docFilePath = [docEnumerator nextObject])) {
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:docFilePath];
        NSDictionary *fileAttributes = [[NSFileManager defaultManager]  attributesOfItemAtPath:fullPath error:nil];
        LPFileInfo* fi = [[LPFileInfo alloc] init];
        fi.fiName = docFilePath;
        fi.fiModDate = [fileAttributes fileModificationDate];
       [filesArray addObject:fi];
    }
    
    [filesArray sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(LPFileInfo*)a fiModDate];
        NSDate *second = [(LPFileInfo*)b fiModDate];
        return ![first compare:second];
    }];
    if([filesArray count]>3)
        [filesArray removeObjectsInRange:NSMakeRange(3, [filesArray count]-3)];
    
    return filesArray;
}

- (NSArray*)receiveImagesFilesList{
    NSArray *homeDomains = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [homeDomains objectAtIndex:0];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:documentsDirectory
                                                      error:nil];
    
    NSMutableArray *arrayOfImages = [[NSMutableArray alloc] init];
    for (int count = 0; count < files.count; count++) {
        NSString* fileName = [files objectAtIndex:count];
        //if hidden file or not supported image
        if ([fileName characterAtIndex:0] == '.' || !([fileName rangeOfString:@".png"].location != NSNotFound
            || [fileName rangeOfString:@".jpg"].location != NSNotFound)) {
            continue;
        }
        LPFileInfo* fi = [[LPFileInfo alloc] init];
        [fi fillWithName:[files objectAtIndex:count] withURL:[documentsDirectory stringByAppendingPathComponent:[files objectAtIndex:count]]];
        [arrayOfImages addObject:fi];
    }
    return arrayOfImages;
}

- (void)deleteFileWithInfo:(LPFileInfo*)fi withType:(BOOL)isProjectFile{
    NSError *error;
    NSArray *homeDomains = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [homeDomains objectAtIndex:0];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if(isProjectFile){
        documentsDirectory = [documentsDirectory stringByAppendingFormat:@"/Projects/%@",fi.fiName];
    }else{
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:fi.fiName];
    }
    NSLog(@"%@",documentsDirectory);
    [fileManager removeItemAtPath:documentsDirectory error:&error];
    if (error) {
        [[[UIAlertView alloc] initWithTitle:@"File manager error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
    } 
}

- (NSArray*)readLayersFromProjectFile:(LPFileInfo*)fi{
    NSMutableArray* layers = [NSMutableArray array];
    NSError* err = nil;
    NSArray *homeDomains = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [homeDomains objectAtIndex:0];
    TBXML* pf = [[TBXML alloc] initWithXMLString:[NSString stringWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Projects/%@",fi.fiName]] encoding:NSUTF8StringEncoding error:&err] error:&err];
    TBXMLElement* root = [pf rootXMLElement];
    int count = -1;
    if(root){
        TBXMLElement* lcountEl = [TBXML childElementNamed:@"LPLayersCount" parentElement:root];
        if (lcountEl) {
            count = [[TBXML textForElement:lcountEl] intValue];
        }
        TBXMLElement* layerEl = [TBXML childElementNamed:@"LPFileLayer" parentElement:root];
        while (layerEl) {
            TBXMLElement* layerNameEl = [TBXML childElementNamed:@"LPLayerName" parentElement:layerEl];
            NSString* name = @"";
            float opac = 1.0;
            BOOL vis = false;
            NSData* data = nil;
            if(layerNameEl)
                name = [TBXML textForElement:layerNameEl];
            TBXMLElement* layerOpacityEl = [TBXML childElementNamed:@"LPLayerOpacity" parentElement:layerEl];
            if(layerOpacityEl)
                opac = [[TBXML textForElement:layerOpacityEl] floatValue];
            TBXMLElement* layerVisEl = [TBXML childElementNamed:@"LPLayerVisibility" parentElement:layerEl];
            if(layerVisEl)
                vis = [[TBXML textForElement:layerVisEl] boolValue];
            TBXMLElement* layerDataEl = [TBXML childElementNamed:@"LPLayerData" parentElement:layerEl];
            if(layerDataEl)
                data = [[TBXML textForElement:layerDataEl] base64toData];
            
            LPLayerData* ld = [[LPLayerData alloc] initWithName:name withData:data withVis:vis withOpacity:opac];
            [layers addObject:ld];
            layerEl = [TBXML nextSiblingNamed:@"LPFileLayer" searchFromElement:layerEl];
        }
    }
    return layers;
}

@end
