//
//  LPLayerData.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 06.12.12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPLayerData : NSObject
@property (nonatomic,strong) NSString* lName;
@property (nonatomic,strong) NSData* lData;
@property (nonatomic) BOOL lVis;
@property (nonatomic) float lOpac;

- (id)initWithName:(NSString*)name withData:(NSData*)data withVis:(BOOL)vis withOpacity:(float)opac;

@end
