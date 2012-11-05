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
@property (nonatomic,retain) LPSmartLayer* currLayer;
@property (nonatomic) int currLayerIndex;
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

- (void)setCurrLayerWithIndex:(int)nIndex{
    if(self.rootLayer && self.layersArray && [self.layersArray count]>0)
        if(nIndex>=0 && nIndex<=[self.layersArray count]-1){
            self.currLayer = [self.layersArray objectAtIndex:nIndex];
            self.currLayerIndex = nIndex;
        }
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
    if(self.rootLayer && self.layersArray && [self.layersArray count]>0){
        [self.currLayer removeFromSuperlayer];
        [self.layersArray removeObjectAtIndex:self.currLayerIndex];
        if ([self.layersArray count]>0) {
            [self setCurrLayerWithIndex:0];
        }
    }
}
- (void)clearLayerAtIndex:(int)nIndex{
    if(self.rootLayer && self.layersArray && [self.layersArray count]>0){
        if ([self.currLayer respondsToSelector:@selector(clear)]) {
            [self.currLayer clear];
        }
    }
}

- (void)changeLayerAtIndex:(int)nIndex withVisibility:(BOOL)nVis{
    if(self.rootLayer && self.layersArray && [self.layersArray count]>0){
        self.currLayer.hidden = !nVis;
    }
}

@end
