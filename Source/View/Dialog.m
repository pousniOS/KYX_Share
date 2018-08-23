
#import "Dialog.h"
#import <unistd.h>

//#import "LeafNotification.h"
//#import "UIImage+GIF.h"

@implementation Dialog


static CGFloat const    DOpacity                                             = 0.56;
static Dialog *instance = nil;

+ (Dialog *)Instance
{
    @synchronized(self)
    {
        if (instance == nil) {
            instance = [self new];
        }
    }
    return instance;
}



+ (void)toast:(UIViewController *)controller withMessage:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
	hud.mode = MBProgressHUDModeText;
	hud.labelText = message;
	hud.margin = 15.f;
	hud.yOffset = 150.f;
    hud.cornerRadius=5;
    hud.opacity=DOpacity;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:1];
}


+ (void)toast:(NSString *)message withPosition:(float)position
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
	hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoomOut;
	hud.labelText = message;
    hud.cornerRadius=5;
	hud.margin = 14.f;
    hud.opacity=DOpacity;
	hud.yOffset = position; 
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:1];
}


+ (void)toast:(NSString *)message withPosition:(float)position delay:(float)time
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.labelText = message;
    hud.cornerRadius=5;
    hud.margin = 14.f;
    hud.yOffset = position;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:time];
}


+ (void)toast:(NSString *)message delay:(float)time {
    if (message.length==0) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
	hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoomOut;
	hud.labelText = message;
    hud.cornerRadius = 5;
	hud.margin = 14.f;
	hud.yOffset = 150.f;
    hud.opacity=DOpacity;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:time];
    CGRect rect = hud.frame;
    hud.frame = CGRectZero;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hud.frame = rect;
    });
}


+ (void)toastCenter:(NSString *)message {
    if (message.length==0) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
	hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled = NO;
    hud.animationType = MBProgressHUDAnimationZoomOut;
	hud.labelText = message;
	hud.margin = 14.f;
    hud.cornerRadius=5;
	hud.yOffset = -20.f;
     hud.opacity=DOpacity;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:2];
}

+ (void)toastCustoastCenter:(NSString *)message {
    if (message.length==0) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
	hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationZoomOut;

    UILabel *notic = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 90)];
    notic.text = message;
    notic.textAlignment = NSTextAlignmentCenter;
    notic.font = [UIFont systemFontOfSize:17];
    notic.textColor = [UIColor whiteColor];
    notic.numberOfLines = 0;
    hud.opacity=DOpacity;
    hud.customView = notic;
    hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:1.75];
}


+(void)hideAllKeywindowHUD
{
  [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
}


+ (void)toastCustoastCenter:(NSString *)message delay:(float)time {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    
    UILabel *notic = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 90)];
    notic.text = message;
    notic.textAlignment = NSTextAlignmentCenter;
    notic.font = [UIFont systemFontOfSize:17];
    notic.textColor = [UIColor whiteColor];
    notic.numberOfLines = 0;
    hud.customView = notic;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:time];
}

+ (void)progressToast:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
	hud.mode = MBProgressHUDModeIndeterminate;
	hud.labelText = message;
	hud.margin = 10.f;
	hud.yOffset = -20.f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:1];
}


- (void)gradient:(UIViewController *)controller seletor:(SEL)method {
    HUD = [[MBProgressHUD alloc] initWithView:controller.view];
	[controller.view addSubview:HUD];
//	HUD.dimBackground = YES;
	HUD.delegate = self;
	[HUD showWhileExecuting:method onTarget:controller withObject:nil animated:YES];
}

- (void)showProgress:(UIViewController *)controller {
    HUD = [[MBProgressHUD alloc] initWithView:controller.view];
    [controller.view addSubview:HUD];
//    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
}

- (void)showProgress:(UIViewController *)controller withLabel:(NSString *)labelText {
    HUD = [[MBProgressHUD alloc] initWithView:controller.view];
    [controller.view addSubview:HUD];
    HUD.delegate = self;
//    HUD.dimBackground = YES;
    HUD.labelText = labelText;
    [HUD show:YES];
}

- (void)showCenterProgressWithLabel:(NSString *)labelText
{
    HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.delegate = self;
    //    HUD.dimBackground = YES;
    HUD.labelText = labelText;
    [HUD show:YES];
}

- (void)hideProgress {
    [HUD hide:YES];
}

- (void)progressWithLabel:(UIViewController *)controller seletor:(SEL)method {
    HUD = [[MBProgressHUD alloc] initWithView:controller.view];
    [controller.view addSubview:HUD];
    HUD.delegate = self;
    //HUD.labelText = @"数据加载中...";
    [HUD showWhileExecuting:method onTarget:controller withObject:nil animated:YES];
}

#pragma mark -
#pragma mark Execution code

- (void)myTask {
	sleep(3);
}

- (void)myProgressTask {
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.01f;
		HUD.progress = progress;
		usleep(50000);
	}
}

- (void)myMixedTask {
	sleep(2);
	HUD.mode = MBProgressHUDModeDeterminate;
	HUD.labelText = @"Progress";
	float progress = 0.0f;
	while (progress < 1.0f)
	{
		progress += 0.01f;
		HUD.progress = progress;
		usleep(50000);
	}
	HUD.mode = MBProgressHUDModeIndeterminate;
	HUD.labelText = @"Cleaning up";
	sleep(2);
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]] ;
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"Completed";
	sleep(2);
}

#pragma mark -
#pragma mark NSURLConnectionDelegete

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	expectedLength = [response expectedContentLength];
	currentLength = 0;
	HUD.mode = MBProgressHUDModeDeterminate;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	currentLength += [data length];
	HUD.progress = currentLength / (float)expectedLength;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
	HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:1];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[HUD hide:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	[HUD removeFromSuperview];
	HUD = nil;
}


#pragma mark---------hhhhhh------
+(void)toastCustom:(NSString *)message delay:(float)time {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled=NO;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.labelText = message;
    hud.cornerRadius=5;
    hud.margin = 14.f;
    hud.yOffset = 150.f;
    hud.opacity=DOpacity;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:time];
}




@end
