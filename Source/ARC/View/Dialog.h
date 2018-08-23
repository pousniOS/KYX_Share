

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"


@interface Dialog : NSObject<MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
    
	long long expectedLength;
	long long currentLength;
}

+ (Dialog *)Instance;
//类似于Android一个显示框效果
/**
 *  显示在屏幕中间
 *  不锁定屏幕，可响应其它事件
 */
+ (void)toast:(UIViewController *)controller withMessage:(NSString *) message;
+ (void)toast:(NSString *)message delay:(float)time;

+ (void)toast:(NSString *)message withPosition:(float)position;
+ (void)toast:(NSString *)message withPosition:(float)position delay:(float)time;


+ (void)toastCenter:(NSString *)message;

+ (void)hideAllKeywindowHUD;

@end
/*   使用
 *  [[Dialog Instance] showCenterProgressWithLabel:@"请稍候"];
 *  [[Dialog Instance] hideProgress];
 *  [Dialog simpleToast:@"连接超时，请稍后再试"];

 */
