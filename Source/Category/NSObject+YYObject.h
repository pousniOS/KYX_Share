//
//  NSObject+YYObject.h
//  KuaiYiXiao
//
//  Created by POSUN-MAC on 16/6/14.
//  Copyright © 2016年 POSUN-MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dialog.h"
@interface NSObject (YYObject)
/**
 NSStirng|NSDictionary|NSArray|自己定义的类|
 **/
-(NSDictionary *)toDictionary;
+(BOOL)isNumber:(NSString *)numberStirng;
+(id)newObject:(id)object;

+(NSString *)checkNil:(NSString *)value;
/**
 获取对象的成员变量名
 **/
-(NSArray *)propertyArray;
-(NSDictionary *)dataModelDictionary;
@end
