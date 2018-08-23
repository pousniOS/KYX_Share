//
//  YYDownH5Model.m
//  KuaiYiXiao
//
//  Created by POSUN-MAC on 2018/4/18.
//  Copyright © 2018年 POSUN-MAC. All rights reserved.
//

#import "YYDownH5Model.h"
@implementation YYDownH5Model

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([value isMemberOfClass:[NSNumber class]])
    {
        value=[NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"id"])
    {
        [super setValue:value forKey:@"Id"];
    }
    else if ([key isEqualToString:@"isUpdate"]){
        [super setValue:@([value boolValue]) forKey:@"Id"];
    }
    else
    {
        [super setValue:value forKey:key];
    }
}

+(void)checkUpdateDown:(ResponseBlack)responseBlack{
    [ShareHttpRequest httpGetRequestWrithUrl:URL(@"/eidpws/core/common/upgrade/kyx_h5") andParam:nil andModelName:nil andRequestResponseBlack:^(id object, NSError *error, YYShareHttpRequest *shareHttpRequest) {
        if (YYShareHttpRequestError) {
            return ;
        }
        YYDownH5Model *oldModel=[YYDownH5Model getDownH5Model];
        YYDownH5Model *newModel=[[YYDownH5Model alloc] init];
        [newModel setValuesForKeysWithDictionary:object];
        NSArray *localVersionArr = [oldModel.applicationVersion componentsSeparatedByString:@"."];
        NSArray *applicationVersionArr = [newModel.applicationVersion componentsSeparatedByString:@"."];
        NSInteger count=localVersionArr.count;
        if (count>applicationVersionArr.count) {
            count=applicationVersionArr.count;
        }
        BOOL update = NO;
        if (count>0) {
            for (int i = 0; i < count; i++) {
                if ([applicationVersionArr[i] integerValue]> [localVersionArr[i] integerValue]) {
                    update = YES;
                }else if([applicationVersionArr[i] integerValue]< [localVersionArr[i] integerValue]){
                    update=NO;
                    break;
                }
            }
        }else{
            update = YES;
        }
        WEAKSELF
        newModel.isUpdate=update;
        responseBlack(weakSelf,newModel);
    }];
}

+(void)downloadFileURL:(NSString *)url andSaveFileName:(NSString *)nameFile andEventBlack:(ResponseBlack)responseBlack{
    //1.创建url
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *savePath=[cachePath stringByAppendingPathComponent:nameFile];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath]) {
//        responseBlack(nil,savePath);
//        return;
//    }location
    NSURL *URL=[NSURL URLWithString:url];
    //2.创建请求
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    //3.创建会话（这里使用了一个全局会话）并且启动任务
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask=[session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!error) {
            //注意location是下载后
            NSError *saveError;
            NSURL *saveUrl=[NSURL fileURLWithPath:savePath];
            [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveUrl error:&saveError];
            dispatch_sync(dispatch_get_main_queue(), ^{
                responseBlack(nil,savePath);
                if (!saveError) {
                    responseBlack(nil,savePath);
                    
                }else{
                    responseBlack(nil,nil);
                }
            });
            
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                responseBlack(nil,nil);
            });
        }
    }];
    [downloadTask resume];
}
-(NSString *)fileName{
    return [[self.url componentsSeparatedByString:@"/"] lastObject];
}
+(YYDownH5Model *)getDownH5Model{
    NSDictionary *dic =[[NSUserDefaults standardUserDefaults] objectForKey:DownH5ModelInformation];
    YYDownH5Model *model=[[YYDownH5Model alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
-(void)saveDownH5Model{
    [[NSUserDefaults standardUserDefaults] setObject:[self toDictionary] forKey:DownH5ModelInformation];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)filePath{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"dist"];
    
}
@end
