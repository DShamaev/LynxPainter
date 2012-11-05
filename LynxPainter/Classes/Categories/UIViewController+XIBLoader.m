//
//  UIViewController+XIBLoader.m
//  LynxPainter
//
//  Created by Администратор on 11/6/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import "UIViewController+XIBLoader.h"

@implementation UIViewController (XIBLoader)

-(id)objectWithNibName:(NSString *)nibNameOrNil withClass:(NSString*)xibName{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil];
    for (id currentObject in topLevelObjects){
        if ([currentObject isKindOfClass:NSClassFromString(xibName)]){
            return currentObject;
            break;
        }
    }
    return nil;
}

@end
