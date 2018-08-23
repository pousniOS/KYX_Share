//
//  UIViewController+Add.h
//  KuaiYiXiao
//
//  Created by POSUN-MAC on 2017/8/8.
//  Copyright © 2017年 POSUN-MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BillTypeCallBack)(NSString *);

@interface UIViewController (Add)

@property(nonatomic, copy) BillTypeCallBack billBlock; ///<聊天时候的单据分享block

+ (UIViewController *)getCurrentVC;

@end
