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
    return [NSMutableArray array];
}
- (NSMutableArray*)receiveImagesFilesList{
    NSArray *homeDomains = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [homeDomains objectAtIndex:0];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:documentsDirectory
                                                      error:nil];
    
    NSMutableArray *arrayOfImages = [[NSMutableArray alloc] init];
    for (int count = 0; count < files.count; count++) {
        LPFileInfo* fi = [[LPFileInfo alloc] init];
        [fi fillWithName:[files objectAtIndex:count] withURL:[files objectAtIndex:count]];
        [arrayOfImages addObject:fi];
    }
    return arrayOfImages;
}

@end
