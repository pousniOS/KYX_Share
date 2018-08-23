//
//  SetpasswordViewController.h
//  AliPayDemo
//
//  Created by pg on 15/7/15.
//  Copyright (c) 2015年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainData.h"
#import "AliPayViews.h"
@interface SetpasswordViewController : UIViewController
@property(nonatomic ,copy)NSString *string;
@property(nonatomic,strong)AliPayViews *aliPayViews;
@property(nonatomic,copy)EventBlack eventBlack;

@end
