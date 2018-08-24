//  NSString+StringExt.h
//  MobileSiBu
//
//  Created by luo.h on 15-4-17.
//  Copyright (c) 2015年 sibu.cn. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (StringExt)
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;


+ (BOOL)isStringEmpty:(NSString *)stringValue;

- (BOOL)isEmptyString;

/**
 *  判断这个字符串是否为空
 *
 *  @param content 需要替换的 nil
 *
 *  @return   yes or no
 */
+ (BOOL)isEmpty:(NSString *)content;
/**
 *  去除字符串前面和后面的空格
 *
 *  @param content 需要去除的字符串
 *
 *  @return 去除完成的字符串
 */
+ (NSString *)trim:(NSString *)content;
/**
 *  替换没有返回改字段内容,所得到内容为 nil 的字段
 *
 *  @param string  nil 字段
 *
 *  @return 返回一个长度为0的字符串
 */
+ (NSString *)replaceNil:(NSString *)string;
/**
 *  判断一个字符串中是否包含另外一个字符串,兼容 iOS8之前系统
 *
 *  @param string 传入子窜
 *
 *  @return 返回知否包含该子串
 */
- (BOOL)isContainsOfString:(NSString *)string;
/**
 *  类方法调用,传入两个字符串,一个是完整的字符串,另外一个字子串,兼容 iOS8 之前系统
 *
 *  @param string    完整的字符串
 *  @param subString 子串
 *
 *  @return 返回知否包含该子串
 */
+ (BOOL)isContainsOfString:(NSString *)string WithSubString:(NSString *)subString;
/**
 *  获取网络状态，区分2G3G4GWIFI等，非reachability
 */
+ (NSString *)getNetWorkStates;
/**
 *  类方法调用,传入一个 json 字符串,返回一个字典
 *
 *  @param string    完整的字符串
 *
 *  @return 返回字典
 */
+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;

//字典转字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
/** 判断输入的字符是不是数字 包含. */
+ (BOOL)validateNumber:(NSString*)number;

/**
 base64解码
 */
- (NSString *)base64DecodedString;

- (NSString *)base64EncodedString;


/// 是否包含表情
- (BOOL)containsEmoji;
@end
