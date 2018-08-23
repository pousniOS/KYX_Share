//
//  YYHTTPHeaderFieldModel.h
//  KuaiYiXiao
//
//  Created by POSUN-MAC on 2018/3/16.
//  Copyright © 2018年 POSUN-MAC. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "YYHttpClientInfoModel.h"
@interface YYHTTPHeaderFieldModel : NSObject
@property(nonatomic,copy,readonly)NSString *timestamp;//当前时间戳
@property(nonatomic,copy,readonly)NSString *appKey;//分配给对应APP的APP_KEY
@property(nonatomic,copy)NSString *token;//登录时为空，登录后的接口请求都需要该token
@property(nonatomic,copy)YYHttpClientInfoModel *clientInfo;//使用base64编码的json字符串,仅登录接口需要
@property(nonatomic,copy,readonly)NSString *sign;//将 appKey + secret + timestamp + token 进行MD5 32位加密后得出的字符串。secret为平台给每个APP分配的，不会变更 切勿将secret放在请求中
+(YYHTTPHeaderFieldModel*)share;
@end
