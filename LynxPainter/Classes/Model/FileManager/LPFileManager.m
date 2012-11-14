//
//  LPFileManager.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 11/14/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPFileManager.h"
#import "LPFileInfo.h"

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

- (NSMutableArray*)receiveProjectsFilesList{
    NSArray *homeDomains = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [homeDomains objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Projects"];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSLog(@"%@",documentsDirectory);
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
- (NSMutableArray*)receiveImagesFilesList{
    NSArray *homeDomains = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [homeDomains objectAtIndex:0];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSLog(@"%@",documentsDirectory);
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

@end
