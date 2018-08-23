//
//  YYHttpClientInfoModel.m
//  KuaiYiXiao
//
//  Created by POSUN-MAC on 2018/3/16.
//  Copyright © 2018年 POSUN-MAC. All rights reserved.
//
      
#import "YYHttpClientInfoModel.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
@implementation YYHttpClientInfoModel
-(NSString *)loginClient{
    return @"IPhone";
}
-(NSString*)imsi{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mcc = [carrier mobileCountryCode];
    NSString *mnc = [carrier mobileNetworkCode];
    NSString *imsi = [NSString stringWithFormat:@"%@%@", mcc, mnc];
    return imsi;
}
-(NSString *)esn{
    return @"";
}
-(NSString *)productModel{
    if (!_productModel) {
        _productModel=[[UIDevice currentDevice] model];
    }
    return _productModel;
}
-(NSString *)appVersion{
    return [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

-(NSString *)getInforStr{
    NSDictionary *dic=[self toDictionary];
    NSString *jsonString=[NSString dictionaryToJson:dic];
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" "withString:@""options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n"withString:@""options:NSLiteralSearch range:range2];
    NSData *headParanmData=[jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * headBase64String=[headParanmData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSRange range3 = {0,headBase64String.length};
    NSMutableString *headBase64StringMutableString=[NSMutableString stringWithString:headBase64String];
    [headBase64StringMutableString replaceOccurrencesOfString:@"\n"withString:@""options:NSLiteralSearch range:range3];
    NSRange range4 = {0,headBase64StringMutableString.length};
    [headBase64StringMutableString replaceOccurrencesOfString:@"\r"withString:@""options:NSLiteralSearch range:range4];
    return headBase64StringMutableString;
}
@end
