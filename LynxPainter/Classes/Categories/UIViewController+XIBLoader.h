//
//  UIViewController+XIBLoader.h
//  LynxPainter
//
//  Created by Администратор on 11/6/12.
//  Copyright (c) 2012 DmitriyShamaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (XIBLoader)
-(id)objectWithNibName:(NSString *)nibNameOrNil withClass:(NSString*)xibName;
@end
