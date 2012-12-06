//
//  LPSmartLayerManager.m
//  LynxPainter
//
//  Created by Администратор on 11/5/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPSmartLayerManager.h"
#import "LPSmartLayer.h"
#import "LPHistoryManager.h"
#import "LPWorkAreaView.h"
#import "LPFileInfo.h"
#import "LPSmartLayerDelegate.h"
#import "LPFileManager.h"
#import "LPLayerData.h"

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
        sharedInstance.currLayerIndex = -1;
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

- (void)moveLayerToIndex:(int)nindex{
    if(self.rootLayer && self.layersArray && [self.layersArray count]>1){
            LPSmartLayer* nLayer = [self.layersArray objectAtIndex:nindex];
            LPSmartLayer* oLayer = [self.layersArray objectAtIndex:self.currLayerIndex];
            [self.layersArray removeObjectAtIndex:self.currLayerIndex];
            [self.layersArray insertObject:nLayer atIndex:self.currLayerIndex];
            [self.layersArray removeObjectAtIndex:nindex];
            [self.layersArray insertObject:oLayer atIndex:nindex];
            self.currLayerIndex=nindex;
    }
}

- (LPSmartLayer*)addNewLayer{
    if(self.rootLayer){
        LPSmartLayer* nLayer = [[LPSmartLayer alloc] initWithName:[NSString stringWithFormat:@"Layer %d",_layerCounter] withColor:[UIColor blackColor] withLineWidth:self.currLayer != nil ? self.currLayer.smLineWidth : 10*self.currScale];
        nLayer.smReadOnly = NO;
        if(!self.layersArray)
            self.layersArray = [NSMutableArray array];
        [self.layersArray addObject:nLayer];
        [self.rootLayer addSublayer:nLayer];
        self.layerCounter +=1;
        return nLayer;
    }
    return nil;
}

- (LPSmartLayer*)addNewImageLayer:(UIImage*)image{
    if(self.rootLayer){
        LPSmartLayer* nLayer = [[LPSmartLayer alloc] initWithName:[NSString stringWithFormat:@"Layer %d",_layerCounter] withColor:[UIColor blackColor] withLineWidth:self.currLayer != nil ? self.currLayer.smLineWidth : 10*self.currScale];
        nLayer.smReadOnly = NO;
        if(!self.layersArray)
            self.layersArray = [NSMutableArray array];
        [self.layersArray addObject:nLayer];
        [self.rootLayer addSublayer:nLayer];
        self.layerCounter +=1;
        CALayer* imageLayer = [CALayer layer];
        imageLayer.contents = (id)image.CGImage;
        imageLayer.frame = self.rootView.bounds;
        [nLayer addSublayer:imageLayer];
        return nLayer;
    }
    return nil;
}
- (void)removeLayer{
    if(self.rootLayer && self.layersArray && [self.layersArray count]>0){
        [[LPHistoryManager sharedManager] clearItemsForLayer:self.currLayer.smName];
        [self.currLayer removeFromSuperlayer];
        [self.layersArray removeObjectAtIndex:self.currLayerIndex];
        if ([self.layersArray count]>0) {
            [self setCurrLayerWithIndex:[self.layersArray count]-1];
        }
        if([self.layersArray count] == 0){
            self.layerCounter = 0;
            [self addNewLayer];
        }
    }
}
- (void)clearLayer{
    if(self.rootLayer && self.layersArray && [self.layersArray count]>0){
        if ([self.currLayer respondsToSelector:@selector(clear)]) {
            [self.currLayer clear];
        }
    }
}

- (void)undo{
    [[LPHistoryManager sharedManager] undo];
}

- (void)partialUndo{
    [self.currLayer removeLastTemporaryChanges];
}

- (void)readImageFile:(LPFileInfo*)fi{
    NSArray *homeDomains = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [homeDomains objectAtIndex:0];
    UIImage* img = [UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:fi.fiName]];
    LPSmartLayer* nLayer = [[LPSmartLayer alloc] initWithName:[NSString stringWithFormat:@"Layer %d",_layerCounter] withColor:[UIColor blackColor] withLineWidth:self.currLayer != nil ? self.currLayer.smLineWidth : 10*self.currScale];
    nLayer.smReadOnly = YES;
    CALayer* imageLayer = [CALayer layer];
    imageLayer.contents = (id)img.CGImage;
    imageLayer.frame = self.rootView.bounds;
    [nLayer addSublayer:imageLayer];
    
    if(!self.layersArray)
        self.layersArray = [NSMutableArray array];
    [self.layersArray addObject:nLayer];
    [self.rootLayer addSublayer:nLayer];
    self.layerCounter +=1;
    [self setCurrLayer:nLayer];
    [self setCurrLayerAlpha:1.0];
    [self setCurrLayerVisibility:YES];
}

- (void)readProjectFile:(LPFileInfo*)fi{
    NSArray* arr = [[LPFileManager sharedManager] readLayersFromProjectFile:fi];
    for (int i=0; i< [arr count]; i++) {
        [self addLayerWithLayerData:[arr objectAtIndex:i]];
    }
}

- (void)addLayerWithLayerData:(LPLayerData*)ld{
    LPSmartLayer* nLayer = [[LPSmartLayer alloc] initWithName:ld.lName withColor:[UIColor blackColor] withLineWidth:self.currLayer != nil ? self.currLayer.smLineWidth : 10*self.currScale];
    nLayer.smReadOnly = NO;
    CALayer* imageLayer = [CALayer layer];
    imageLayer.contents = (id)[UIImage imageWithData:ld.lData].CGImage;
    imageLayer.frame = self.rootView.bounds;
    [nLayer addSublayer:imageLayer];
    
    if(!self.layersArray)
        self.layersArray = [NSMutableArray array];
    [self.layersArray addObject:nLayer];
    [self.rootLayer addSublayer:nLayer];
    self.layerCounter +=1;
    [self setCurrLayer:nLayer];
    [self setCurrLayerAlpha:ld.lOpac];
    [self setCurrLayerVisibility:ld.lVis];
    
    CALayer* mplayer = [CALayer layer];
    mplayer.frame = self.currLayer.bounds;
    LPSmartLayerDelegate* del = [self.currLayer requestNewDelegate];
    del.signPath = CGPathCreateMutable();
    mplayer.delegate = del;
    self.currLayer.smCurrSLayer = mplayer;
    [self.currLayer addSublayer:mplayer ];
}

- (void)clearManagerData{
    self.currLayerIndex = -1;
    self.currLayer = nil;
    self.layersArray = nil;
    self.rootLayer = nil;
    self.rootView = nil;
    self.currScale = 1;
    self.layerCounter = 0;
}

@end
