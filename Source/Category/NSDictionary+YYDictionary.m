//
//  DicToJson(NSString).m
//  fossil-ipad
//
//  Created by POSUN-MAC on 15/11/18.
//  Copyright © 2015年 user. All rights reserved.
//

#import "NSDictionary+YYDictionary.h"

@implementation  NSDictionary(YYDictionary)
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    if (dic) {
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil){return nil;}
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error=nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error)
    {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}
@end
