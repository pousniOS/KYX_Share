//
//  YYHttpClientInfoModel.h
//  KuaiYiXiao
//
//  Created by POSUN-MAC on 2018/3/16.
//  Copyright © 2018年 POSUN-MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYHttpClientInfoModel : NSObject
@property(nonatomic,copy)NSString *tenantId;//租户编号
@property(nonatomic,copy)NSString *empId;//登录的用户名
@property(nonatomic,copy,readonly)NSString *loginClient;//登录的终端，参见loginClient枚举
@property(nonatomic,copy,readonly)NSString *imsi;//设备的IMSI
@property(nonatomic,copy,readonly)NSString *esn;//ESN号
//@property(nonatomic,copy)NSString *phone;//手机号
@property(nonatomic,copy,readonly)NSString *appVersion;//当前APP版本号
//@property(nonatomic,copy)NSString *osVersion;//操作系统版本号
@property(nonatomic,copy)NSString *productModel;//手机型号

-(NSString *)getInforStr;

@end
