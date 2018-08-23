//
//  YYHTTPHeaderFieldModel.m
//  KuaiYiXiao
//
//  Created by POSUN-MAC on 2018/3/16.
//  Copyright © 2018年 POSUN-MAC. All rights reserved.
//

#import "YYHTTPHeaderFieldModel.h"
#import "NSString+Hashing.h"


@implementation YYHTTPHeaderFieldModel
+(YYHTTPHeaderFieldModel*)share{
    static dispatch_once_t onceToken;
    static YYHTTPHeaderFieldModel *HTTPHeaderFieldModel=nil;
    dispatch_once(&onceToken, ^{
        HTTPHeaderFieldModel=[[YYHTTPHeaderFieldModel alloc] init];
    });
    return HTTPHeaderFieldModel;
}


#pragma mark - ============ Get ============
-(NSString *)timestamp{

    NSDate *datenow = [NSDate date];
    NSTimeInterval interval = [datenow timeIntervalSince1970];
    long long totalMilliseconds = interval*1000 ;
    NSString *timeSp = [NSString stringWithFormat:@"%llu", totalMilliseconds];
    
    
    NSMutableString *signMutableString=[[NSMutableString alloc] init];
    [signMutableString appendString:self.appKey];//AppKey
    [signMutableString appendString:@"PTIIZdGUwW8P"];//SECRET
    [signMutableString appendString:timeSp];
    [signMutableString appendString:self.token];
    _sign=[[NSString MD5ForLower32Bate:signMutableString] uppercaseString];
    
    
    return timeSp;
}
//将NSDate类型的时间转换为时间戳,从1970/1/1开始
-(long long)getDateTimeTOMilliSeconds:(NSDate *)datetime
{
    NSTimeInterval interval = [datetime timeIntervalSince1970];
//    NSLog(@"转换的时间戳=%f",interval);
    long long totalMilliseconds = interval*1000 ;
//    NSLog(@"totalMilliseconds=%llu",totalMilliseconds);
    return totalMilliseconds;
}

-(NSString *)appKey{
    return @"4yB7353D";
}
//-(NSString *)sign{
//NSMutableString *signMutableString=[[NSMutableString alloc] init];
//[signMutableString appendString:self.appKey];//AppKey
//[signMutableString appendString:@"PTIIZdGUwW8P"];//SECRET
//[signMutableString appendString:self.timestamp];
//[signMutableString appendString:self.token];
//_sign=[[NSString MD5ForLower32Bate:signMutableString] uppercaseString];
//}
-(NSString *)token{
    if (!_token) {
        _token=@"";
    }
    return _token;
}

-(YYHttpClientInfoModel *)clientInfo{
    if (!_clientInfo) {
        _clientInfo=[[YYHttpClientInfoModel alloc] init];
    }
    return _clientInfo;
}
@end
