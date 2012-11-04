//
//  LPSmartLayerManager.m
//  LynxPainter
//
//  Created by Администратор on 11/5/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPSmartLayerManager.h"
#import "LPSmartLayer.h"

@interface LPSmartLayerManager ()
@property (nonatomic) int layerCounter;
@property (nonatomic,retain) NSMutableArray* layersArray;
@end

@implementation LPSmartLayerManager

+ (LPSmartLayerManager *)sharedManager {
    static LPSmartLayerManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LPSmartLayerManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (LPSmartLayer*)addNewLayer{
    if(self.rootLayer){
        LPSmartLayer* nLayer = [[LPSmartLayer alloc] init];
        [nLayer fillWithName:[NSString stringWithFormat:@"Layer %d",_layerCounter] withColor:[UIColor blackColor] withLineWidth:1];
        if(!self.layersArray)
            self.layersArray = [NSMutableArray array];
        [self.layersArray addObject:nLayer];
        [self.rootLayer addSublayer:nLayer];
        return nLayer;
    }
    return nil;
}
- (void)removeLayerAtIndex:(int)nIndex{
    if(self.rootLayer && self.layersArray && [self.layersArray count]>0)
        if(nIndex>=0 && nIndex<=[self.layersArray count]-1){
            LPSmartLayer* rLayer = [self.layersArray objectAtIndex:nIndex];
            [rLayer removeFromSuperlayer];
            [self.layersArray removeObjectAtIndex:nIndex];
        }
}
- (void)clearLayerAtIndex:(int)nIndex{
    if(self.rootLayer && self.layersArray && [self.layersArray count]>0)
        if(nIndex>=0 && nIndex<=[self.layersArray count]-1){
            LPSmartLayer* rLayer = [self.layersArray objectAtIndex:nIndex];
            if ([rLayer respondsToSelector:@selector(clear)]) {
                [rLayer clear];
            }
        }
}

- (void)changeLayerAtIndex:(int)nIndex withVisibility:(BOOL)nVis{
    if(self.rootLayer && self.layersArray && [self.layersArray count]>0)
        if(nIndex>=0 && nIndex<=[self.layersArray count]-1){
            LPSmartLayer* rLayer = [self.layersArray objectAtIndex:nIndex];
            rLayer.hidden = !nVis;
        }
}

@end
