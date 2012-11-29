//
//  LPFileManager.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 11/14/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPFileInfo;

@interface LPFileManager : NSObject
+ (LPFileManager *)sharedManager;
- (NSArray*)receiveProjectsFilesList;
- (NSArray*)receiveImagesFilesList;
- (void)deleteFileWithInfo:(LPFileInfo*)fi withType:(BOOL)isProjectFile;
@end
