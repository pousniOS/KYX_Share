//
//  SetpasswordViewController.m
//  AliPayDemo
//
//  Created by pg on 15/7/15.
//  Copyright (c) 2015年 pg. All rights reserved.
//

#import "SetpasswordViewController.h"
#import "YYDownH5Model.h"
#import "SVProgressHUD.h"
#import "SSZipArchive.h"
@interface SetpasswordViewController ()

@end

@implementation SetpasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    /************************* start **********************************/
    
    AliPayViews *alipay = [[AliPayViews alloc] initWithFrame:self.view.bounds];
    _aliPayViews=alipay;
    if ([self.string isEqualToString:@"验证密码"]) {
        alipay.gestureModel = ValidatePwdModel;
    } else if ([self.string isEqualToString:@"修改密码"]) {
        alipay.gestureModel = AlertPwdModel;
    } else if ([self.string isEqualToString:@"重置密码"]) {
        alipay.gestureModel = SetPwdModel;
    } else if ([self.string isEqualToString:@"删除密码"]) {
        alipay.gestureModel = DeletePwdModel;
    }
    else {
        alipay.gestureModel = NoneModel;
    }
    WEAKSELF
    alipay.block = ^(NSString *pswString) {
        NSLog(@"设置密码成功-----你的密码为 = 【%@】\n\n", pswString);
        if(![weakSelf.string isEqualToString:@"验证密码"]){
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
        if(_eventBlack){
            _eventBlack(weakSelf,pswString);
        }
    };
    
    [self.view addSubview:alipay];
    
    /************************* end **********************************/

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 64, 64);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    [self downH5];
}

- (void)back  {
    WEAKSELF
    [self dismissViewControllerAnimated:YES completion:nil];
    if(_eventBlack){
        _eventBlack(weakSelf,@"black");
    }
}
-(void)downH5{
    /**检测H5的更新**/
    [YYDownH5Model checkUpdateDown:^(id event, id information) {
        YYDownH5Model *downH5Model=information;
        if (downH5Model.isUpdate) {
            UIAlertController  *alertController=[UIAlertController alertControllerWithTitle:@"提示" message:downH5Model.remark preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
                /**移除旧文件下载**/
                NSString *documentDirectoryPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *filePath = [documentDirectoryPath stringByAppendingPathComponent:@"dist"];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                BOOL result = [fileManager fileExistsAtPath:filePath];
                if (result) {
                    NSError *error=nil;
                    [fileManager removeItemAtPath:filePath error:&error];
                }
                NSString *cachesDirectoryPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                filePath = [cachesDirectoryPath stringByAppendingPathComponent:@"dist.zip"];
                result = [fileManager fileExistsAtPath:filePath];
                if (result) {
                    NSError *error=nil;
                    [fileManager removeItemAtPath:filePath error:&error];
                }
                
                [SVProgressHUD show];
                [YYDownH5Model downloadFileURL:URL(downH5Model.url) andSaveFileName:[downH5Model fileName] andEventBlack:^(UIResponder *responder, id information) {
                    [SVProgressHUD dismiss];
                    if (information) {
                        [downH5Model saveDownH5Model];
                        NSString *destination=documentDirectoryPath;
                        [SSZipArchive unzipFileAtPath:information toDestination:destination];
                    }
                }];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
