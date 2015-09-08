//
//  UIView+Common.m
//  CiweiProtect
//
//  Created by 吴启飞 on 15/3/18.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Common)
- (UIViewController *)myViewController {
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass:[UIViewController class]])
            return (UIViewController *)responder;
    // If the view controller isn't found, return nil.
    return nil;
}
@end
