//
//  YYShareHttpRequest.m
//  KuaiYiXiao
//
//  Created by POSUN-MAC on 16/1/5.
//  Copyright © 2016年 POSUN-MAC. All rights reserved.
//
#import "YYShareHttpRequest.h"
#import "NSString+Hashing.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#define ORIGINAL_MAX_WIDTH 750.0f   //图片最大宽度
static YYShareHttpRequest *shareHttpRequest=nil;
@implementation YYShareHttpRequest
#pragma mark - ============ 请求方法 ============
#pragma mark - 数据解析
-(void)dataAnalysis:(NSURLResponse *)response andData:(NSData *)data andError:(NSError *)connectionError andModelName:(NSString *)modelName{
    if (!connectionError){
        NSError *error=nil;
        id object=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        _rawData=object;
        _data=data;
        if (error){
            [self.delegate requestResponse:nil andError:error and:self];
        }else{
            /**
             解析
             {
             "status": true,
             "msg": "操作成功",
             "data": {}
             }
             **/
            if ([object isKindOfClass:[NSDictionary class]]&&
                object[@"status"]&&
                object[@"data"]) {
                if ([object[@"status"] integerValue] && ![object[@"data"] isEqual:[NSNull null]]) {
                    object=object[@"data"];
                }
                /**请求错误情况判断**/
                else if (![object[@"status"] integerValue]){
                    if (self.autoShowErrorMsg) {
                        [Dialog toast:object[@"msg"] delay:2.0f];
                    }
                    [self.delegate requestResponse:object andError:[[NSError alloc] init] and:self];
                     return;
                }
                else if ([object[@"data"] isEqual:[NSNull null]]) {
                    if ([object[@"status"] integerValue]) {
                        [self.delegate requestResponse:object andError:nil and:self];
                    }else{
                        [self.delegate requestResponse:object andError:[[NSError alloc] init] and:self];
                    }
                    return;
                }else if ([object[@"data"] isKindOfClass:[NSString class]] &&[object[@"data"] isEqualToString:@"<null>"]) {
                    if ([object[@"status"] integerValue]) {
                        [self.delegate requestResponse:object andError:nil and:self];
                    }else{
                        [self.delegate requestResponse:object andError:[[NSError alloc] init] and:self];
                    }
                    return;
                }else if ([object[@"data"] isKindOfClass:[NSArray class]] &&![object[@"data"] count]) {
                    [self.delegate requestResponse:object andError:nil and:self];
                    return;
                }
                else{
                    if (self.autoShowErrorMsg) {
                        if ([object isKindOfClass:[NSDictionary class]] &&[object[@"code"] integerValue]==1078) {
                            [self outLogin:object];
                        }else{
                            [Dialog toast:object[@"msg"] delay:2.0f];
                        }
                    }else{
                        [self.delegate requestResponse:object andError:nil and:self];
                    }
                    return;
                }
            }
            if (modelName.length>0){
                /**
                 object->NSArray
                 **/
                if ([object isKindOfClass:[NSArray class]]){
                    NSMutableArray *mutableArray=[[NSMutableArray alloc] init];
                    for (NSDictionary *value in object){
                        id model =[[NSClassFromString(modelName) alloc] init];
                        [model setValuesForKeysWithDictionary:value];
                        [mutableArray addObject:model];
                    }
                    if ([_delegate respondsToSelector:@selector(requestResponse:andError:and:)]) {
                        [_delegate requestResponse:mutableArray andError:nil and:self];
                    }
                }
                /**
                 object->NSDictionary
                 **/
                else if ([object isKindOfClass:[NSDictionary class]]){
                    if (object[@"errorMsg"]){
                        /**
                         请求消息数量时不提示报错
                         **/
                        if (![modelName isEqualToString:@"YYFindTaskModel"]) {
                            [Dialog toast:object[@"errorMsg"] delay:2.0f];
                        }if (self.autoShowErrorMsg) {
                            [Dialog toast:object[@"errorMsg"] delay:2.0f];
                        }
                        if ([self.delegate respondsToSelector:@selector(requestResponse:andError:and:)]) {
                            [self.delegate requestResponse:object andError:[NSError new] and:self];
                        }
                        return;
                    }
                    else if (object[@"data"]&&[object[@"data"] isKindOfClass:[NSString class]]){
//                        object =[self dictionaryWithJsonString:object[@"data"]];
                        object =[NSDictionary dictionaryWithJsonString:object[@"data"]];
                        if ([object isKindOfClass:[NSArray class]]){
                            NSMutableArray *mutableArray=[[NSMutableArray alloc] init];
                            for (NSDictionary *value in object){
                                id model =[[NSClassFromString(modelName) alloc] init];
                                [model setValuesForKeysWithDictionary:value];
                                [mutableArray addObject:model];
                            }
                            if ([_delegate respondsToSelector:@selector(requestResponse:andError:and:)]) {
                                [_delegate requestResponse:mutableArray andError:nil and:self];
                            }
                            
                        }
                        else if ([object isKindOfClass:[NSDictionary class]]){
                            if (object[@"errorMsg"]){
                                /**
                                 请求消息数量时不提示报错
                                 **/
                                if (![modelName isEqualToString:@"YYFindTaskModel"]) {
                                    [Dialog toast:object[@"errorMsg"] delay:2.0f];
                                }
                                if (self.autoShowErrorMsg) {
                                    [Dialog toast:object[@"errorMsg"] delay:2.0f];
                                }
                                if ([self.delegate respondsToSelector:@selector(requestResponse:andError:and:)]) {
                                    [self.delegate requestResponse:object andError:[NSError new] and:self];
                                }
                                return;
                            }
                            else if (object[@"msg"]){
                                [Dialog toast:object[@"msg"] delay:2.0f];
                                if ([_delegate respondsToSelector:@selector(requestResponse:andError:and:)]) {
                                    [_delegate requestResponse:object andError:nil and:self];
                                }
                            }
                            else{
                                id model =[[NSClassFromString(modelName) alloc] init];
                                [model setValuesForKeysWithDictionary:object];
                                if ([_delegate respondsToSelector:@selector(requestResponse:andError:and:)]) {
                                    [_delegate requestResponse:model andError:nil and:self];
                                }
                            }
                        }else{
                            if ([_delegate respondsToSelector:@selector(requestResponse:andError:and:)]) {
                                [_delegate requestResponse:object andError:nil and:self];
                            }
                        }
                    }
                    else{
                        id model =[[NSClassFromString(modelName) alloc] init];
                        [model setValuesForKeysWithDictionary:object];
                        if ([_delegate respondsToSelector:@selector(requestResponse:andError:and:)]) {
                            [_delegate requestResponse:model andError:nil and:self];
                        }
                    }
                }else{
                    if ([_delegate respondsToSelector:@selector(requestResponse:andError:and:)]) {
                        [_delegate requestResponse:object andError:nil and:self];
                    }
                }
            }else{
                if ([object isKindOfClass:[NSDictionary class]]){
                    if (object[@"errorMsg"]){
                        /**
                         请求消息数量时不提示报错
                         **/
                        if (![modelName isEqualToString:@"YYFindTaskModel"]) {
                            [Dialog toast:object[@"errorMsg"] delay:2.0f];
                        }
                        if (self.autoShowErrorMsg) {
                            [Dialog toast:object[@"errorMsg"] delay:2.0f];
                        }
                        if ([self.delegate respondsToSelector:@selector(requestResponse:andError:and:)]) {
                            [self.delegate requestResponse:object andError:[NSError new] and:self];
                        }
                        return;
                    }
                }
                if ([_delegate respondsToSelector:@selector(requestResponse:andError:and:)]) {
                    [_delegate requestResponse:object andError:nil and:self];
                }
            }
        }
    }else{
        [Dialog toast:@"服务器连接失败" delay:2.0f];
    }
}
-(void)dataAnalysis:(NSURLResponse *)response andData:(NSData *)data andError:(NSError *)connectionError andModelName:(NSString *)modelName andRequestResponseBlack:(RequestResponseBlack)requestResponseBlack{
    if (!connectionError){
        NSError *error=nil;
        id object=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        _rawData=object;
        _data=data;
        if (error){
            requestResponseBlack(nil,error,self);
        }else{
            if ([object isKindOfClass:[NSDictionary class]]&&object[@"status"]&&object[@"data"]) {
                if ([object[@"status"] integerValue] && ![object[@"data"] isEqual:[NSNull null]]) {
                    object=object[@"data"];
                }
                /**请求错误情况判断**/
                else if (![object[@"status"] integerValue]){
                    if (self.autoShowErrorMsg) {
                        if ([object isKindOfClass:[NSDictionary class]] &&[object[@"code"] integerValue]==1078) {
                            [self outLogin:object];
                        }else{
                            [Dialog toast:object[@"msg"] delay:2.0f];
                        }
                    }
                    requestResponseBlack(object,[[NSError alloc] init],self);
                    return;
                }
                else if ([object[@"data"] isEqual:[NSNull null]]) {
                    if ([object[@"status"] integerValue]) {
                        
                        requestResponseBlack(object/*object[@"data"]*/,nil,self);
                    }else{
                        requestResponseBlack(object/*object[@"data"]*/,[[NSError alloc] init],self);
                    }
                    return;
                }else if ([object[@"data"] isKindOfClass:[NSString class]] &&[object[@"data"] isEqualToString:@"<null>"]) {
                    if ([object[@"status"] integerValue]) {
                        requestResponseBlack(object/*object[@"data"]*/,nil,self);
                    }else{
                        requestResponseBlack(object/*object[@"data"]*/,[[NSError alloc] init],self);
                    }
                    return;
                }else if ([object[@"data"] isKindOfClass:[NSArray class]] &&![object[@"data"] count]) {
                    requestResponseBlack(object/*object[@"data"]*/,nil,self);
                    return;
                }
                else{
                    if (self.autoShowErrorMsg) {
                        [Dialog toast:object[@"msg"] delay:2.0f];
                    }else{
                        requestResponseBlack(object,nil,self);
                    }
                    return;
                }
            }
            if (modelName.length>0){
                /**
                 object->NSArray
                 **/
                if ([object isKindOfClass:[NSArray class]])
                {
                    NSMutableArray *mutableArray=[[NSMutableArray alloc] init];
                    for (NSDictionary *value in object)
                    {
                        id model =[[NSClassFromString(modelName) alloc] init];
                        [model setValuesForKeysWithDictionary:value];
                        [mutableArray addObject:model];
                    }
                    requestResponseBlack(mutableArray,nil,self);
                }
                /**
                 object->NSDictionary
                 **/
                else if ([object isKindOfClass:[NSDictionary class]]){
                    if (object[@"errorMsg"]){
                        /**
                         请求消息数量时不提示报错
                         **/
                        if (![modelName isEqualToString:@"YYFindTaskModel"]) {
                            [Dialog toast:object[@"errorMsg"] delay:2];
                        }
                        if (self.autoShowErrorMsg) {
                            [Dialog toast:object[@"errorMsg"] delay:2];
                        }
                        requestResponseBlack(object,nil,self);
                    }
                    else if (object[@"data"]&&[object[@"data"] isKindOfClass:[NSString class]]){
                        if ([object isKindOfClass:[NSDictionary class]]) {
                            if (object[@"timestamp"]) {
                                self.expandDic=[@{@"timestamp":object[@"timestamp"]} mutableCopy];
                            }
                            if (object[@"removedData"]) {
//                                id removedData =[self dictionaryWithJsonString:object[@"removedData"]];
                                
                                id removedData =[NSDictionary dictionaryWithJsonString:object[@"removedData"]];

                                if (removedData&&[removedData isKindOfClass:[NSArray class]]) {
                                    [self.expandDic setObject:removedData forKey:@"removedData"];
                                }
                            }
                        }
//                        object =[self dictionaryWithJsonString:object[@"data"]];
                        
                        object=[NSDictionary dictionaryWithJsonString:object[@"data"]];
                        
                        if ([object isKindOfClass:[NSArray class]]){
                            NSMutableArray *mutableArray=[[NSMutableArray alloc] init];
                            for (NSDictionary *value in object){
                                id model =[[NSClassFromString(modelName) alloc] init];
                                [model setValuesForKeysWithDictionary:value];
                                [mutableArray addObject:model];
                            }
                            requestResponseBlack(mutableArray,nil,self);
                        }
                        else if ([object isKindOfClass:[NSDictionary class]]){
                            if (object[@"errorMsg"]){
                                /**
                                 请求消息数量时不提示报错
                                 **/
                                if (![modelName isEqualToString:@"YYFindTaskModel"]) {
                                    [Dialog toast:object[@"errorMsg"] delay:2];
                                }
                                if (self.autoShowErrorMsg) {
                                    [Dialog toast:object[@"errorMsg"] delay:2];
                                }
                                requestResponseBlack(object,error,self);
                            }
                            else if (object[@"msg"]){
                                if (self.autoShowErrorMsg) {
                                    [Dialog toast:object[@"msg"] delay:2.0f];
                                }
                                requestResponseBlack(object,nil,self);
                            }
                            else{
                                id model =[[NSClassFromString(modelName) alloc] init];
                                [model setValuesForKeysWithDictionary:object];
                                requestResponseBlack(model,nil,self);
                            }
                        }
                        else{
                            requestResponseBlack(object,nil,self);
                        }
                    }
                    else{
                        id model =[[NSClassFromString(modelName) alloc] init];
                        [model setValuesForKeysWithDictionary:object];
                        requestResponseBlack(model,nil,self);
                    }
                }
                /**
                 object->其他类对象
                 **/
                else{
                    requestResponseBlack(object,nil,self);
                }
            }
            else
            {
                if ([object isKindOfClass:[NSDictionary class]])
                {
                    if (object[@"errorMsg"])
                    {
                        /**
                         请求消息数量时不提示报错
                         **/
                        if (self.autoShowErrorMsg) {
            
                            
                            [Dialog toast:object[@"errorMsg"] delay:2];

                        }
                        requestResponseBlack(object,error,self);
                        return;
                    }
                }
                requestResponseBlack(object,nil,self);
            }
        }
    }else{
        [Dialog toast:@"服务器连接失败" delay:2];
    }
}
#pragma mark - GET请求
-(void)httpGetRequestWrithUrl:(NSString *)url andParam:(NSDictionary *)paramDic andModelName:(NSString *)modelName{
    YYShareHttpRequest *shareHttpRequest=[YYShareHttpRequest share];
    if (!self.isNoShowLoadDictionary[self.flag]
        ){
        [SVProgressHUD show];
    }
    NSMutableURLRequest *mutableRequest=[shareHttpRequest getHTTPRequestURL:url aneParam:paramDic];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:mutableRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismissWithDelay:SVProgressHUDDismissWithDelay];
            [self dataAnalysis:response andData:data andError:error andModelName:modelName];
        });
    }];
    [dataTask resume];
}
-(void)httpGetRequestWrithUrl:(NSString *)url andParam:(NSDictionary *)paramDic andModelName:(NSString *)modelName andRequestResponseBlack:(RequestResponseBlack)requestResponseBlack{
    self.flag=modelName;
    YYShareHttpRequest *shareHttpRequest=[YYShareHttpRequest share];
    if (!self.isNoShowLoadDictionary[self.flag]){[SVProgressHUD show];}
    
    NSMutableURLRequest *mutableRequest=[shareHttpRequest getHTTPRequestURL:url aneParam:paramDic];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:mutableRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismissWithDelay:SVProgressHUDDismissWithDelay];
            [self dataAnalysis:response andData:data andError:error andModelName:modelName andRequestResponseBlack:requestResponseBlack];
        });
    }];
    [dataTask resume];
}
#pragma mark - POST请求
-(void)httpPostRequestWrithUrl:(NSString *)url andParam:(NSDictionary *)paramDic andModelName:(NSString *)modelName{
    YYShareHttpRequest *shareHttpRequest=[YYShareHttpRequest share];
    [SVProgressHUD show];
    [self lock];
    NSMutableURLRequest *mutableURLRequest=[shareHttpRequest postJSONHTTPRequestURL:url andJsonDic:paramDic];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:mutableURLRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismissWithDelay:SVProgressHUDDismissWithDelay];
            [self unlock];
            [self dataAnalysis:response andData:data andError:error andModelName:modelName];
        });
    }];
    [dataTask resume];
}
/**锁住屏幕防止多次请求操作**/
-(void)lock{
    UIViewController *viewController=[UIViewController getCurrentVC];
    if (viewController) {
        viewController.view.userInteractionEnabled=NO;
        [[YYShareHttpRequest share].currentViewControllers addObject:viewController];
    }
}
/**解除锁屏**/
-(void)unlock{
    [[YYShareHttpRequest share].currentViewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *viewController=obj;
        viewController.view.userInteractionEnabled=YES;
    }];
    [[YYShareHttpRequest share].currentViewControllers removeAllObjects];
}

-(void)httpPostRequestWrithUrl:(NSString *)url andParam:(NSDictionary *)paramDic andModelName:(NSString *)modelName andRequestResponseBlack:(RequestResponseBlack)requestResponseBlack{
    YYShareHttpRequest *shareHttpRequest=[YYShareHttpRequest share];
    [SVProgressHUD show];
    [self lock];
    NSMutableURLRequest *mutableURLRequest=[shareHttpRequest postJSONHTTPRequestURL:url andJsonDic:paramDic];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:mutableURLRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismissWithDelay:SVProgressHUDDismissWithDelay];
            [self unlock];
            [self dataAnalysis:response andData:data andError:error andModelName:modelName andRequestResponseBlack:requestResponseBlack];
        });
    }];
    [dataTask resume];
}
#pragma mark - 上传图片
/**
 代理方式
 **/
-(void)httpUploadPictures:(NSArray *)array fileName:(NSString*)fileName andUrl:(NSString *)url{
    [SVProgressHUD show];

    NSMutableURLRequest *request=[[AFHTTPSessionManager shareManager].requestSerializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSDictionary * paramDic in array){
            if (![paramDic[uploadPicture] isMemberOfClass:[NSString class]]){
                id object=paramDic[uploadPicture];
                
                if ([object isKindOfClass:[UIImage class]]) {
                    object = [self imageByScalingToMaxSize:paramDic[uploadPicture]];
                    [formData appendPartWithFileData:[self compressionImage:object] name:fileName fileName:paramDic[uploadPictureNmae] mimeType:@"application/octet-stream"];
                }else{
                    [formData appendPartWithFileData:object name:fileName fileName:paramDic[uploadPictureNmae] mimeType:@"application/octet-stream"];
                }
            }
        }
    } error:nil];
    
    NSURLSessionUploadTask *sessionUploadTask =[[AFHTTPSessionManager shareManager] uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
//            NSError *error=nil;
//            id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
//            if (!error)
//            {
//                [_delegate requestResponse:object andError:nil and:self];
//            }
//            else
//            {
//                [_delegate requestResponse:nil andError:error and:self];
//            }
            [_delegate requestResponse:responseObject andError:nil and:self];

        }else{
            [_delegate requestResponse:nil andError:error and:self];
        }
        [SVProgressHUD dismissWithDelay:SVProgressHUDDismissWithDelay];
    }];
    [sessionUploadTask resume];
}
/**
 black方式
 **/
-(void)httpUploadPictures:(NSArray *)array fileName:(NSString*)fileName andUrl:(NSString *)url andRequestResponseBlack:(RequestResponseBlack)requestResponseBlack{
    [SVProgressHUD show];
    
    NSMutableURLRequest *request=[[AFHTTPSessionManager shareManager].requestSerializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSDictionary * paramDic in array){
            if (![paramDic[uploadPicture] isMemberOfClass:[NSString class]]){
                id object=paramDic[uploadPicture];
                
                if ([object isKindOfClass:[UIImage class]]) {
                    object = [self imageByScalingToMaxSize:paramDic[uploadPicture]];
                    
                    ;
                    
                    [formData appendPartWithFileData:[self compressionImage:object] name:fileName fileName:paramDic[uploadPictureNmae] mimeType:@"application/octet-stream"];
                }else{
                    [formData appendPartWithFileData:object name:fileName fileName:paramDic[uploadPictureNmae] mimeType:@"application/octet-stream"];
                }
            }
        }
    } error:nil];
    
    
    NSURLSessionUploadTask *sessionUploadTask =[[AFHTTPSessionManager shareManager] uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            requestResponseBlack(responseObject,nil,self);
        }else{
            requestResponseBlack(nil,error,self);
        }
        [SVProgressHUD dismissWithDelay:SVProgressHUDDismissWithDelay];
    }];
    [sessionUploadTask resume];
}
#pragma mark - ============ 创建请求对象V2 ============
/**
 创建一个GET请求对像
 **/
-(NSMutableURLRequest*)getHTTPRequestURL:(NSString *)url aneParam:(NSDictionary *)paramDic{
    TBLog(@"\n===============================\n\nMETHOD:GET\nURL:%@\nPARAM:%@\n\n===============================",url,[NSString dictionaryToJson:paramDic]);
    NSString *URL;
    if ([YYShareHttpRequest doWithParams:paramDic] && [YYShareHttpRequest doWithParams:paramDic].length>0){
        URL=[NSString stringWithFormat:@"%@?%@",url,[YYShareHttpRequest doWithParams:paramDic]];
    }else{
        URL=[NSString stringWithFormat:@"%@",url];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
    [request setTimeoutInterval:timeoutInterval];
    
    
    
    [request setValue:[YYHTTPHeaderFieldModel share].timestamp forHTTPHeaderField:@"timestamp"];
    [request setValue:[YYHTTPHeaderFieldModel share].appKey forHTTPHeaderField:@"appKey"];
    [request setValue:[YYHTTPHeaderFieldModel share].token forHTTPHeaderField:@"token"];
    [request setValue:[YYHTTPHeaderFieldModel share].clientInfo.getInforStr forHTTPHeaderField:@"info"];
    [request setValue:[YYHTTPHeaderFieldModel share].sign forHTTPHeaderField:@"sign"];
    request.HTTPMethod=@"GET";
    return request;
}
/**URL
 创建一个POST请求对像
 **/
-(NSMutableURLRequest*)postJSONHTTPRequestURL:(NSString *)url andJsonDic:(NSDictionary *)jsonDic{
    TBLog(@"\n===============================\n\nMETHOD:POST\nURL:%@\nPARAM:%@\n\n===============================",url,[NSString dictionaryToJson:jsonDic]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:timeoutInterval];
    [request setValue:[YYHTTPHeaderFieldModel share].timestamp forHTTPHeaderField:@"timestamp"];
    [request setValue:[YYHTTPHeaderFieldModel share].appKey forHTTPHeaderField:@"appKey"];
    [request setValue:[YYHTTPHeaderFieldModel share].token forHTTPHeaderField:@"token"];
    [request setValue:[YYHTTPHeaderFieldModel share].clientInfo.getInforStr forHTTPHeaderField:@"info"];
    [request setValue:[YYHTTPHeaderFieldModel share].sign forHTTPHeaderField:@"sign"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod=@"POST";
    NSData * jsonData=jsonDic?[NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil]:nil;
    request.HTTPBody = jsonData;
    return request;
}
/**
 创建一个请求管理对象（AF不建议使用）
 **/
//-(AFHTTPRequestOperationManager*)mangerHead{
//    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
//    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
//    manger.requestSerializer.timeoutInterval = 5.0f;
//    [manger.requestSerializer setValue:self.HTTPHeaderFieldModel.timestamp forHTTPHeaderField:@"timestamp"];
//    [manger.requestSerializer setValue:self.HTTPHeaderFieldModel.appKey forHTTPHeaderField:@"appKey"];
//    [manger.requestSerializer setValue:self.HTTPHeaderFieldModel.token forHTTPHeaderField:@"token"];
//    [manger.requestSerializer setValue:self.HTTPHeaderFieldModel.clientInfo.getInforStr forHTTPHeaderField:@"info"];
//    [manger.requestSerializer setValue:self.HTTPHeaderFieldModel.sign forHTTPHeaderField:@"sign"];
//    return manger;
//}
#pragma mark - ============ 其他 ============

+ (NSString *)headerDate{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"EEE,dd MMM yyyy HH:mm:ss";
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [f setTimeZone:timeZone];
    f.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    NSDate *nowDate = [NSDate date];
    NSString *resultStr = [f stringFromDate:nowDate];
    resultStr = [NSString stringWithFormat:@"%@ GMT",resultStr];
    return resultStr;
}
/**
 初始的请求头
 **/
+(YYShareHttpRequest *)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareHttpRequest=[[YYShareHttpRequest alloc] init];
        shareHttpRequest.currentViewControllers=[[NSMutableArray alloc] init];
    });
    shareHttpRequest.autoShowErrorMsg = YES;
    return shareHttpRequest;
}
/**
 拼接参数
 **/
+(NSString *)doWithParams:(NSDictionary *)paramDic{
    NSMutableArray *newArr = [NSMutableArray new];
    for (NSString *key in paramDic){
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,paramDic[key] ];
        [newArr addObject:str];
    }
    return  [[newArr componentsJoinedByString:@"&"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage{
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH){
        return sourceImage;
    }
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height){
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    }else{
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor){
            scaleFactor = widthFactor; // scale to fit height
        }
        else{
            scaleFactor = heightFactor; // scale to fit width
        }
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)outLogin:(NSDictionary *)dic{
    UIViewController *currentViewController =[UIViewController getCurrentVC];
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提示" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
    if (currentViewController) {
        [currentViewController presentViewController:alertController animated:YES completion:nil];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            /**不论请求成功还是失败都退出登录**/
//            [DXUserModel share].isRegister=NO;
            
            
            
            [UIApplication sharedApplication].delegate.window.rootViewController=[[UINavigationController alloc] initWithRootViewController:[[NSClassFromString(@"YYRegisterViewController") alloc] init]];
        }]];
    }
}


#pragma mark - ============ 懒加载 ============
- (instancetype)init {
    if (self = [super init]) {
        self.autoShowErrorMsg = YES;
    }
    return self;
}
-(NSDictionary *)isNoJsonFlagDictionary{
    return @{
             @"approveTasK_FindTaskCount":@"approveTasK_FindTaskCount",
             };
}
-(NSDictionary*)isNoShowLoadDictionary{
    return @{@"YYFindTaskModel":@"YYFindTaskModel",
             @"YYFindTaskModel":@"YYFindTaskModel",
             @"YYScheduleFindTaskNumModel":@"YYScheduleFindTaskNumModel",
             @"YYFindTaskModel":@"YYFindTaskModel",
             @"YYIdFindByBizModel":@"YYIdFindByBizModel",
             @"yyworkingDynamicSave":@"yyworkingDynamicSave",
             @"yyApproveTaskIDApproval":@"yyApproveTaskIDApproval",
             @"TBWorkingDynamicModel":@"TBWorkingDynamicModel",
             @"YYNoticeFindModel":@"YYNoticeFindModel"};
}
-(NSString *)host{
    if (!_host){
        NSString *host=[[NSUserDefaults standardUserDefaults] objectForKey:@"yyHost"];
        if (host.length){
            _host=host;
        }else{
//          _host =@"https://test.oksales.net";
            _host =@"https://oksales.net";
        }
    }
    return _host;
}


-(NSData*)compressionImage:(UIImage *)image{
    NSInteger b=1024;
    NSString *type=[YYShareHttpRequest share].pictureCompressionRatioTpye;
    if ([type isEqualToString:PictureQuality_Auto]) {
        if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus]==AFNetworkReachabilityStatusReachableViaWiFi) {
            return [image compressWithMaxLength:1024*b];
        }else{
            return [image compressWithMaxLength:800*b];
        }
    }else if ([type isEqualToString:PictureQuality_High]){
        return [image compressWithMaxLength:1024*b];
    }else if ([type isEqualToString:PictureQuality_Medium]){
        return [image compressWithMaxLength:800*b];
    }else if ([type isEqualToString:PictureQuality_Low]){
        return [image compressWithMaxLength:100*b];
    }
    return [image compressWithMaxLength:1024*b];
}
@end
