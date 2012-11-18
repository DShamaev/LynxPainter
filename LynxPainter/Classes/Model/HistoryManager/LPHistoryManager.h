//
//  LPHistoryManager.h
//  LynxPainter
//
//  Created by DmitriyShamaev on 11/18/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPHistoryManager : NSObject

+ (LPHistoryManager *)sharedManager;
- (void)addActionWithLayer:(NSString*)tag;
- (void)clearItemsForLayer:(NSString*)tag;
- (void)undo;

@end
