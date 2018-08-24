//  NSString+StringExt.h
//  MobileSiBu
//
//  Created by luo.h on 15-4-17.
//  Copyright (c) 2015年 sibu.cn. All rights reserved.
#import "NSString+StringExt.h"
/*
 *动态计算文本宽高
 */

@implementation NSString (StringExt)
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = @{}.mutableCopy;
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return CGSizeMake(ceil(result.width), ceil(result.height));//CGSizeCeil(result);
}
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
}



+ (BOOL)isStringEmpty:(NSString *)stringValue
{
    if ((NSNull *)stringValue == [NSNull null])
    {
        return YES;
    }
    if (stringValue == nil) {
        return YES;
    }
    else if ([stringValue length] == 0) {
        return YES;
    }
    else {
        NSString *temp = [stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([temp length] == 0) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isEmpty:(NSString *)content {
    return !content || [content isKindOfClass:[NSNull class]] || [NSString trim:content].length == 0;
}
+ (NSString *)replaceNil:(NSString *)string{
    if ([NSString isEmpty:string]) {
        return @"";
    } else {
        return string;
    }
}

+ (NSString *)trim:(NSString *)content {
    return [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isEmptyString {
    if ((NSNull *)self == [NSNull null]) {
        return YES;
    }
    if (self == nil) {
        return YES;
    }
    else if ([self length] == 0) {
        return YES;
    }
    else {
        NSString *temp = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([temp length] == 0) {
            return YES;
        }
    }
    return NO;
}


- (BOOL)isContainsOfString:(NSString *)string{
    if (!string) {
        return NO;
    }    
    if ([self rangeOfString:string].location == NSNotFound) {
        return NO;
    }
    return YES;
    
}
+ (BOOL)isContainsOfString:(NSString *)string WithSubString:(NSString *)subString{
    if ([string rangeOfString:subString].location == NSNotFound) {
        return NO;
    }
    return YES;
}

+(NSString *)getNetWorkStates{
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    [manager startMonitoring];
//    __block NSString *state = [[NSString alloc]init];
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown:
//                state = @"未识别的网络";
//                break;
//                
//            case AFNetworkReachabilityStatusNotReachable:
//                NSLog(@"不可达的网络(未连接)");
//                state = @"不可达的网络(未连接)";
//                break;
//                
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                NSLog(@"2G,3G,4G...的网络");
//                state = @"2G,3G,4G...的网络";
//                break;
//                
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                NSLog(@"wifi的网络");
//                state = @"wifi的网络";
//                break;
//            default:
//                break;
//        }
//    }];
//    
//    return state;
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}

+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    JSONString = [JSONString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    JSONString = [JSONString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    JSONString = [JSONString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    JSONString = [JSONString stringByReplacingOccurrencesOfString:@";" withString:@","];
    NSDictionary *dic =  [self dictionaryWithJsonString:JSONString];
    return dic;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

//字典转字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    if (dic) {
        NSError *parseError = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
    
 
    
}

+ (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (NSString *)base64DecodedString
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)base64EncodedString {
    NSData *passwordData=[self dataUsingEncoding:NSUTF8StringEncoding];
    NSString * result=[passwordData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return result;
}
@end
