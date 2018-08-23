# KYX_Share
1.手势解锁
2.Responder
3.YYDownH5Model
4.DBModel
5.YYHttpRequest  修改了压缩图片的方法解耦 注释掉了 [DXUserModel share].isRegister
6.AFHTTPSessionManager+Add
7.
#define yyHost [YYShareHttpRequest share].host
#define ShareHttpRequest [[YYShareHttpRequest alloc] init]
#define URL(url) [NSString stringWithFormat:@"%@%@",yyHost,url]
8.Dialog
9.MacroHeader.h
10.MBProgressHUD.h
11.NSObject+YYObject.h
12.加密库
13.#define SVProgressHUDDismissWithDelay (0.3f)

14.
#define PictureQuality_Auto @"Auto"
#define PictureQuality_High @"High"
#define PictureQuality_Medium @"Medium"
#define PictureQuality_Low @"Low"


15.-(NSData*)compressionImage:(UIImage *)image;

16.UIViewController+Add.h

17.NSDictionary+YYDictionary;

18.#define TBLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
19.UIImage+Add.h
20.NSString+IMNSString
21."NSString+StringExt.h"
