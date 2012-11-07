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

- (void)setCurrLayerVisibility:(BOOL)vis{
    if(self.currLayer)
        self.currLayer.hidden = !vis;
}

- (void)setCurrLayerAlpha:(float)alpha{
    if(self.currLayer)
        self.currLayer.opacity = alpha;
}

- (void)moveLayerUp{
    if(self.rootLayer && self.layersArray && [self.layersArray count]>0){
        if(self.currLayerIndex<[self.layersArray count]-1){
            LPSmartLayer* nextLayer = [self.layersArray objectAtIndex:self.currLayerIndex+1];
            [self.layersArray removeObjectAtIndex:self.currLayerIndex];
            [self.layersArray insertObject:self.currLayer atIndex:self.currLayerIndex+1];
            [self.currLayer removeFromSuperlayer];
            [self.rootLayer insertSublayer:self.currLayer above:nextLayer];
            self.currLayerIndex+=1;
        }
    }
}

- (void)moveLayerDown{
    if(self.rootLayer && self.layersArray && [self.layersArray count]>0){
        if(self.currLayerIndex>0){
            LPSmartLayer* prevLayer = [self.layersArray objectAtIndex:self.currLayerIndex-1];
            [self.layersArray removeObjectAtIndex:self.currLayerIndex];
            [self.layersArray insertObject:self.currLayer atIndex:self.currLayerIndex-1];
            [self.currLayer removeFromSuperlayer];
            [self.rootLayer insertSublayer:self.currLayer below:prevLayer];
            self.currLayerIndex-=1;
        }
    }
}

- (LPSmartLayer*)addNewLayer{
    if(self.rootLayer){
        LPSmartLayer* nLayer = [[LPSmartLayer alloc] init];
        nLayer.rootLayerView = self.rootView;
        [nLayer fillWithName:[NSString stringWithFormat:@"Layer %d",_layerCounter] withColor:[UIColor blackColor] withLineWidth:1];
        if(!self.layersArray)
            self.layersArray = [NSMutableArray array];
        [self.layersArray addObject:nLayer];
        [self.rootLayer addSublayer:nLayer];
        self.layerCounter +=1;
        return nLayer;
    }
    return nil;
}
- (void)removeLayerAtIndex:(int)nIndex{
    if(self.rootLayer && self.layersArray && [self.layersArray count]>0){
        [self.currLayer removeFromSuperlayer];
        [self.layersArray removeObjectAtIndex:self.currLayerIndex];
        if ([self.layersArray count]>0) {
            [self setCurrLayerWithIndex:[self.layersArray count]-1];
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
