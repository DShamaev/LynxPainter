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
@class LPWorkAreaView;
@class LPFileInfo;

@interface LPSmartLayerManager : NSObject{
    
}
@property (nonatomic, strong) LPWorkAreaView *rootView;
@property (nonatomic, strong) CALayer *rootLayer;
@property (nonatomic,retain,readonly) NSMutableArray* layersArray;
@property (nonatomic,readonly) int currLayerIndex;
@property (nonatomic) float currScale;
@property (nonatomic,retain) LPSmartLayer* currLayer;

+ (LPSmartLayerManager *)sharedManager;

- (LPSmartLayer*)addNewLayer;
- (LPSmartLayer*)addNewImageLayer:(UIImage*)image;
- (void)setCurrLayerWithIndex:(int)nIndex;
- (void)setCurrLayerVisibility:(BOOL)vis;
- (void)setCurrLayerAlpha:(float)alpha;
- (void)moveLayerToIndex:(int)nindex;
- (void)removeLayer;
- (void)clearLayer;
- (void)undo;
- (void)partialUndo;
- (void)clearManagerData;
- (void)readProjectFile:(LPFileInfo*)fi;
- (void)readImageFile:(LPFileInfo*)fi;

@end
