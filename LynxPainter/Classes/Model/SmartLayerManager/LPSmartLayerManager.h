//
//  LPSmartLayerManager.h
//  LynxPainter
//
//  Created by Администратор on 11/5/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class LPSmartLayer;

@interface LPSmartLayerManager : NSObject{
    
}

@property (nonatomic, strong) CALayer *rootLayer;

+ (LPSmartLayerManager *)sharedManager;

- (LPSmartLayer*)addNewLayer;
- (void)removeLayerAtIndex:(int)nIndex;
- (void)clearLayerAtIndex:(int)nIndex;
- (void)changeLayerAtIndex:(int)nIndex withVisibility:(BOOL)nVis;

@end
