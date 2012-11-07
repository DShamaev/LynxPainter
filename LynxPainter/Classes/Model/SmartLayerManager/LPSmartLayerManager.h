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
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) CALayer *rootLayer;
@property (nonatomic,retain,readonly) NSMutableArray* layersArray;
@property (nonatomic,readonly) int currLayerIndex;
@property (nonatomic,retain) LPSmartLayer* currLayer;

+ (LPSmartLayerManager *)sharedManager;

- (LPSmartLayer*)addNewLayer;
- (void)setCurrLayerWithIndex:(int)nIndex;
- (void)setCurrLayerVisibility:(BOOL)vis;
- (void)setCurrLayerAlpha:(float)alpha;
- (void)moveLayerUp;
- (void)moveLayerDown;
- (void)removeLayer;
- (void)clearLayer;
- (void)changeLayerWithVisibility:(BOOL)nVis;
- (void)undo;

@end
