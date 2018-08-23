//
//  AFHTTPSessionManager+Add.m
//  KuaiYiXiao
//
//  Created by POSUN-MAC on 2018/6/12.
//  Copyright © 2018年 POSUN-MAC. All rights reserved.
//

#import "AFHTTPSessionManager+Add.h"
#import "YYHTTPHeaderFieldModel.h"

@implementation AFHTTPSessionManager (Add)
+(AFHTTPSessionManager *)shareManager{
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    YYHTTPHeaderFieldModel *HTTPHeaderFieldModel=[YYHTTPHeaderFieldModel share];
    [manager.requestSerializer setValue:HTTPHeaderFieldModel.timestamp forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:HTTPHeaderFieldModel.appKey forHTTPHeaderField:@"appKey"];
    [manager.requestSerializer setValue:HTTPHeaderFieldModel.token forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:HTTPHeaderFieldModel.clientInfo.getInforStr forHTTPHeaderField:@"info"];
    [manager.requestSerializer setValue:HTTPHeaderFieldModel.sign forHTTPHeaderField:@"sign"];
    
    return manager;
}
@end
