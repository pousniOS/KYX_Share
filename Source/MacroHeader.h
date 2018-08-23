//
//  MacroHeader.h
//  KuaiYiXiao
//
//  Created by POSUN-MAC on 15/12/10.
//  Copyright © 2015年 POSUN-MAC. All rights reserved.
//

#ifndef MacroHeader_h
#define MacroHeader_h

#endif /* MacroHeader_h */
/*
 宏定义
 */
#define TBLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define WEAKSELF typeof(self) __weak weakSelf = self;

// RGB色
#define RGB(r,g,b,a)  [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:a]

// 用于背景颜色
#define colorBackcolor @"e0e0e0"
// 用于导航栏底色，重要按钮色,重要文字
#define colorMain @"#4ea5dc"
//橙色
#define colorOrange @"#ff9a14"
/**
 *  用于重要级文字信息 如：标题，类目名称等
 */
#define colorImportantText @"#333333"

// 用于普通文字信息。 如：详情，填写的内容等。
#define colorNormalText @"#666666"

// 用于状态显示,警告信息,删除按钮等
#define colorWarning @"#ff4200"

// ----------------------- 新版颜色定义 ------------------------
#define nColorMain @"#2384cf"
//主色：#2384cf
//深主色：#1977bf

#define nDarkColorMain @"#2384cf"
//字体颜色（强调）：#101010
#define nColorImportantText @"#101010"

//字体颜色（辅助 中）：#999999
#define nColorNormalText @"#999999"

//字体颜色（辅助 弱）：#bbbbbb
#define nColorDarkGrayText @"#bbbbbb"

//分割线：#f3f3f3
#define nColorLine @"#f3f3f3"

//间隙：#f9f9f9
#define nColorSpace @"#f9f9f9"

//背景 f5f6f7
#define nColorBackcolor @"f5f6f7"

//橙色
#define nColorOrange @"#ff801a"

// 用于状态显示,警告信息,删除按钮等
#define nColorWarning @"#f74c31"
// ----------------------- 新版颜色定义 - end ------------------------
//整个 APP 统一间距
#define spacing 13
//#define kPadding 5

#define TBCodingFileName(empId,modelId) [NSString stringWithFormat:@"%@%@.tb",empId,modelId]

// 字体
#define Font(size) STHeitiSC_Light(size)
// 像素值
#define horizontal(number) (number) / 750.0 * [[UIScreen mainScreen] bounds].size.width
//获取屏幕宽高的宏定义
#define KScreenBounds ([UIScreen mainScreen].bounds)
//获取屏幕宽度的宏定义
#define KScreenWidth ([UIScreen mainScreen].bounds.size.width)
//获取屏幕高度的宏定义
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)
//获取任意一个视图的宽度
#define KViewWidth(a) ((a).bounds.size.width)
//获取任意一个视图的高度
#define KViewHeight(a) ((a).bounds.size.height)
//获取任意一个视图的X坐标
#define KViewOrignalX(a) ((a).frame.origin.x)
//获取任意一个视图的Y坐标
#define KViewOrignalY(a) ((a).frame.origin.y)
#define GetScreen [UIScreen mainScreen];

#define HYHLabelFont_name 11
#define HYHbackcolor RGB(240, 242, 245, 1)

typedef void(^ResponseBlack)(id event,id information);
#define SVProgressHUDDismissWithDelay (0.3f)

#define kHtmlHead @"<html><head><meta name=\"viewport\" content=\"width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no\"><style type=\"text/css\">body{max-width:100%;background:#0f0; background-color:transparent;} img{max-width:100%;overflow:hidden;}</style></head><body style=\"font-size:13px;\">"

#define kHtmlFoot @"</body></html>"

#define DEFAULTS_OBJ(_NAME)          [[NSUserDefaults standardUserDefaults] objectForKey:_NAME]
#define DEFAULTS_INFO(_OBJECT, _NAME) [[NSUserDefaults standardUserDefaults] setObject:_OBJECT forKey:_NAME]
#define DEFAULTS_SYNCHRONIZE          [[NSUserDefaults standardUserDefaults] synchronize];
