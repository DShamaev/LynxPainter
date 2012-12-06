//
//  LPLayerData.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 06.12.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPLayerData.h"

@implementation LPLayerData

- (id)initWithName:(NSString*)name withData:(NSData*)data withVis:(BOOL)vis withOpacity:(float)opac{
    self = [super init];
    if(self){
        self.lName = name;
        self.lData = data;
        self.lVis = vis;
        self.lOpac = opac;
    }
    return self;
}

@end
