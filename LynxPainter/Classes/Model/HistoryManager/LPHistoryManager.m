//
//  LPHistoryManager.m
//  LynxPainter
//
//  Created by DmitriyShamaev on 11/18/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "LPHistoryManager.h"
#import "LPSmartLayerManager.h"
#import "LPSmartLayer.h"

@interface LPHistoryManager ()

@property (nonatomic,strong) NSMutableArray* history;

@end

@implementation LPHistoryManager

+ (LPHistoryManager *)sharedManager{
    static LPHistoryManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LPHistoryManager alloc] init];
        sharedInstance.history = [NSMutableArray array];
        // Do any other initialisation stuff here
    });
    return sharedInstance;

}

- (void)addActionWithLayer:(NSString*)tag{
    [self.history addObject:tag];
}

- (void)clearItemsForLayer:(NSString*)tag{
    for(int i=0;i<[self.history count];i++)
        if ([[self.history objectAtIndex:i] isEqualToString:tag]) {
            [self.history removeObjectAtIndex:i];
            i--;
        }
}

- (void)undo{
    if([self.history count]>0){
        NSArray* arr = [[LPSmartLayerManager sharedManager] layersArray];
        for(int i=0;i<[arr count];i++){
            LPSmartLayer* sl =[arr objectAtIndex:i];
            if([sl.smName isEqualToString:[self.history lastObject]]){
                LPSmartLayer* sl = [arr objectAtIndex:i];
                [sl removeLastChanges];
                [self.history removeLastObject];
                break;
            }
        }
    }
}

@end
