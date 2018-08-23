//
//  UIButton+Add.h
//  PSOksales
//
//  Created by POSUN-MAC on 17/3/14.
//  Copyright © 2017年 tangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIResponder+PSResponder.h"


@interface UIButton (Add)
/**
 button添加事件
 **/
-(void)addCE:(UIControlEvents)cE andBEB:(EventBlack)bEB;
/**
 1.方法说明:设置button的图片
 2参数说明:
 (1)bIN:默认图片
 (2)bIH:高亮图片
 (3)cE:事件类型
 (4)bEB:事件触发的回调black
 **/
-(void)setBIN:(UIImage*)bIN andBIH:(UIImage *)bIH andCE:(UIControlEvents)cE andBEB:(EventBlack)bEB;
/**
 1.方法说明:设置button的图片
 2参数说明:
 (1)bIN:默认图片
 (2)bIS:选中图片
 (3)cE:事件类型
 (4)bEB:事件触发的回调black
 **/
-(void)setBIN:(UIImage*)bIN andBIS:(UIImage *)bIS andCE:(UIControlEvents)cE andBEB:(EventBlack)bEB;
/**
 1.方法说明:设置button的文字
 2参数说明:
 (1)bTN:默认文字
 (2)bCN:默认文字颜色
 (3)bTH:高亮文字
 (4)bCH:高亮文字颜色
 (5)cE:事件类型
 (6)bEB:事件触发的回调black
 **/
-(void)setBTN:(NSString*)bTN andBCN:(UIColor *)bCN andBTH:(NSString *)bTH andBCH:(UIColor *)bCH andCE:(UIControlEvents)cE andBEB:(EventBlack)bEB;
/**
 1.方法说明:设置button的文字
 2参数说明:
 (1)bTN:默认文字
 (2)bCN:默认文字颜色
 (3)bTH:选中文字
 (4)bCH:选中文字颜色
 (5)cE:事件类型
 (6)bEB:事件触发的回调black
 **/
-(void)setBTN:(NSString*)bTN andBCN:(UIColor *)bCN andBTS:(NSString *)bTS andBCS:(UIColor *)bCS andCE:(UIControlEvents)cE andBEB:(EventBlack )bEB;
@end
