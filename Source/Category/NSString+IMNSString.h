//
//  NSString+YYNSString.h
//  YYTools
//
//  Created by POSUN-MAC on 16/9/14.
//  Copyright © 2016年 POSUN-MAC. All rights reserved.
//

#define JosnString(value) [NSString dictionaryToJson:value]
#define PrintfJosnString(value)  NSLog(@"%@",[NSString dictionaryToJson:value])

#import <Foundation/Foundation.h>

@interface NSString (IMNSSttirngring)
/**
 NSDictionary转NSString
 **/
+ (NSString*)dictionaryToJson:(NSDictionary *)dictionary;
/**
 NSStirng为nil时返回@""
 **/
//+(NSString *)checkNil:(NSString *)value;
/**
 NSDate转NSString
 **/
+ (NSString *)stringFromDate:(NSDate *)date;

+(NSString *)JavaModelToObjectCModel:(NSString *)path;
@end
