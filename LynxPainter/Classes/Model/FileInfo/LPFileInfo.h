//
//  LPFileInfo.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 11/14/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPFileInfo : NSObject
@property (nonatomic,retain) NSString* fiName;
@property (nonatomic,retain) NSString* fiURL;
- (void)fillWithName:(NSString*)name withURL:(NSString*)url;
@end
