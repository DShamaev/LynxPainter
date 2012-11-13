//
//  LPFileInfo.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 11/14/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPFileInfo.h"

@implementation LPFileInfo
- (void)fillWithName:(NSString*)name withURL:(NSString*)url{
    self.fiName = [NSString stringWithString:name];
    self.fiURL = [NSString stringWithString:url];
}
@end
