//
//  NSString+YYNSString.m
//  YYTools
//
//  Created by POSUN-MAC on 16/9/14.
//  Copyright © 2016年 POSUN-MAC. All rights reserved.
//
#import "NSString+IMNSString.h"

@implementation NSString (IMNSString)
+ (NSString*)dictionaryToJson:(NSDictionary *)dictionary
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
//+(NSString *)checkNil:(NSString *)value
//{
//    if ([value isKindOfClass:[NSArray class]]||[value isKindOfClass:[NSDictionary class]]){
//        return value;
//    }
//    if ([value isEqualToString:@""]||!value.length||value==nil||[value isEqualToString:@"(null)"])
//    {
//        return @"";
//    }
//    return value;
//
//}
/**
 NSDate转NSString
 **/
+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(NSString *)JavaModelToObjectCModel:(NSString *)path{
    NSError *error=nil;
    NSString *fS=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSArray *array=[fS componentsSeparatedByString:@"\n"];
    
    NSMutableString *mutableString=[[NSMutableString alloc] init];
    
    for (NSInteger i=0; i<array.count; i++)
    {
        NSString *str=array[i];
        if ([str containsString:@"@MetaData"])
        {
            str =[str stringByReplacingOccurrencesOfString:@" " withString:@""];
            str=[str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSArray *array0= [str componentsSeparatedByString:@"\""];
            if (array0.count>1)
            {
                [mutableString appendString:[NSString stringWithFormat:@"/**\n%@\n**/\n",array0[1]]];
            }
        }
        else if ([str containsString:@"private"])
        {
            str =[str stringByReplacingOccurrencesOfString:@" " withString:@""];
            str =[str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            str =[str stringByReplacingOccurrencesOfString:@"private" withString:@""];
            str =[str stringByReplacingOccurrencesOfString:@"Integer" withString:@""];
            str =[str stringByReplacingOccurrencesOfString:@"String" withString:@""];
            [mutableString appendString:[NSString stringWithFormat:@"@property(nonatomic,copy)NSString * %@\n",str]];
        }
    }
    return mutableString;
}

@end
