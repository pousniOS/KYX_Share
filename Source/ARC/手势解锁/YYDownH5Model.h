//
//  YYDownH5Model.h
//  KuaiYiXiao
//
//  Created by POSUN-MAC on 2018/4/18.
//  Copyright © 2018年 POSUN-MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DownH5ModelInformation @"DownH5ModelInformation"

@interface YYDownH5Model : NSObject
@property(nonatomic,copy)NSString *applicationFlag;
@property(nonatomic,copy)NSString *applicationVersion;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy,readonly)NSString *fileName;
@property(nonatomic,copy)NSString *filePath;//H5文件的位置
@property(nonatomic,copy)NSString *url;
@property(nonatomic,assign)BOOL isUpdate;
@property(nonatomic,copy)NSString *versionCode;
+(void)checkUpdateDown:(ResponseBlack)responseBlack;
+(void)downloadFileURL:(NSString *)url andSaveFileName:(NSString *)nameFile andEventBlack:(ResponseBlack)responseBlack;
+(YYDownH5Model *)getDownH5Model;
-(void)saveDownH5Model;





@end
