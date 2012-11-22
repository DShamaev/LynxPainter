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
#import "TBXML.h"
#import "LPFileInfo.h"
#import "NSString+YBase64toData.h"
#import "LPSmartLayerDelegate.h"

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

- (void)readLayersFromProjectFile:(LPFileInfo*)fi{
    NSError* err = nil;
    NSArray *homeDomains = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [homeDomains objectAtIndex:0];
    TBXML* pf = [[TBXML alloc] initWithXMLString:[NSString stringWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Projects/%@",fi.fiName]] encoding:NSUTF8StringEncoding error:&err] error:&err];
    TBXMLElement* root = [pf rootXMLElement];
    int count = -1;
    if(root){
        TBXMLElement* lcountEl = [TBXML childElementNamed:@"LPLayersCount" parentElement:root];
        if (lcountEl) {
            count = [[TBXML textForElement:lcountEl] intValue];
        }
        TBXMLElement* layerEl = [TBXML childElementNamed:@"LPFileLayer" parentElement:root];
        while (layerEl) {
            TBXMLElement* layerNameEl = [TBXML childElementNamed:@"LPLayerName" parentElement:layerEl];
            NSString* name = @"";
            float opac = 1.0;
            BOOL vis = false;
            NSData* data = nil;
            if(layerNameEl)
                name = [TBXML textForElement:layerNameEl];
            TBXMLElement* layerOpacityEl = [TBXML childElementNamed:@"LPLayerOpacity" parentElement:layerEl];
            if(layerOpacityEl)
                opac = [[TBXML textForElement:layerOpacityEl] floatValue];
            TBXMLElement* layerVisEl = [TBXML childElementNamed:@"LPLayerVisibility" parentElement:layerEl];
            if(layerVisEl)
                vis = [[TBXML textForElement:layerVisEl] boolValue];
            TBXMLElement* layerDataEl = [TBXML childElementNamed:@"LPLayerData" parentElement:layerEl];
            if(layerDataEl)
                data = [[TBXML textForElement:layerDataEl] base64toData];
            LPSmartLayer* nLayer = [[LPSmartLayer alloc] initWithName:name withColor:[UIColor blackColor] withLineWidth:self.currLayer != nil ? self.currLayer.smLineWidth : 10*self.currScale];
            nLayer.smReadOnly = NO;
            CALayer* imageLayer = [CALayer layer];
            imageLayer.contents = (id)[UIImage imageWithData:data].CGImage;
            imageLayer.frame = self.rootView.bounds;
            [nLayer addSublayer:imageLayer];
            
            if(!self.layersArray)
                self.layersArray = [NSMutableArray array];
            [self.layersArray addObject:nLayer];
            [self.rootLayer addSublayer:nLayer];
            self.layerCounter +=1;
            [self setCurrLayer:nLayer];
            [self setCurrLayerAlpha:opac];
            [self setCurrLayerVisibility:vis];
            
            CALayer* mplayer = [CALayer layer];
            mplayer.frame = self.currLayer.bounds;
            LPSmartLayerDelegate* del = [self.currLayer requestNewDelegate];
            del.signPath = CGPathCreateMutable();
            mplayer.delegate = del;
            self.currLayer.smCurrSLayer = mplayer;
            [self.currLayer addSublayer:mplayer ];

            layerEl = [TBXML nextSiblingNamed:@"LPFileLayer" searchFromElement:layerEl];
        }
    }
}

- (void)clearManagerData{
    self.currLayerIndex = -1;
    self.currLayer = nil;
    self.layersArray = nil;
    self.rootLayer = nil;
    self.rootView = nil;
    self.currScale = 1;
}

@end
