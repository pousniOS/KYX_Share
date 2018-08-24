//
//  UIViewController+Add.m
//  KuaiYiXiao
//
//  Created by POSUN-MAC on 2017/8/8.
//  Copyright © 2017年 POSUN-MAC. All rights reserved.
//
#import <objc/runtime.h>
#import "UIViewController+Add.h"

@implementation UIViewController (Add)
+ (UIViewController *)getCurrentVC{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    if (!window) {
        return nil;
    }
    UIView *tempView;
    for (UIView *subview in window.subviews) {
        if ([[subview.classForCoder description] isEqualToString:@"UILayoutContainerView"]) {
            tempView = subview;
            break;
        }
    }
    if (!tempView) {
        tempView = [window.subviews lastObject];
    }
    id nextResponder = [tempView nextResponder];
    while (![nextResponder isKindOfClass:[UIViewController class]] || [nextResponder isKindOfClass:[UINavigationController class]] || [nextResponder isKindOfClass:[UITabBarController class]]) {
        tempView =  [tempView.subviews firstObject];
        
        if (!tempView) {
            return nil;
        }
        nextResponder = [tempView nextResponder];
    }
    return  (UIViewController *)nextResponder;
}

-(void)setBillBlock:(BillTypeCallBack)billBlock{
    objc_setAssociatedObject(self, @"billBlock", billBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BillTypeCallBack )billBlock{
    return objc_getAssociatedObject(self, @"billBlock");
}

@end
