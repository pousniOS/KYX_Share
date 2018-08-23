//
//  NSObject+YYObject.m
//  KuaiYiXiao
//
//  Created by POSUN-MAC on 16/6/14.
//  Copyright © 2016年 POSUN-MAC. All rights reserved.
//

#import "NSObject+YYObject.h"
#import <objc/runtime.h>
@implementation NSObject (YYObject)

+(void)load{
    const char *name=[@"NSCopying" UTF8String];
    Protocol *ptol=objc_getProtocol(name); //获取copy协议
    if (!class_conformsToProtocol(self.class, ptol)) {//判断类是否继承了copy协议
        class_addProtocol(self.class, ptol);//没有就继承
    }
}
- (id)copyWithZone:(nullable NSZone *)zone{//实现copy方法
    Class cls=self.class;
    unsigned int varListCount;
    Ivar *varList= class_copyIvarList(cls, &varListCount);//获取属性变量名列表和变量数量
    
    id obj =[[cls allocWithZone:zone] init];//创建一个新的obj对象
    for (int i=0; i<varListCount; i++) {//给obj赋值
        Ivar var=varList[i];
        object_setIvar(obj, var, [self valueForKey:[NSString stringWithUTF8String:ivar_getName(var)]]);
    }
    free(varList);
    return obj;
}
#pragma makr - Model转Dictionary
-(NSDictionary *)toDictionary{
    NSMutableDictionary *mutableDictionary=[[NSMutableDictionary alloc] init];
    NSArray *propertyArray=[self propertyArray];
    if ([self isKindOfClass:[UIImage class]]||
        [self isKindOfClass:NSClassFromString(@"PSTableViewModel.h")]||
        [self isKindOfClass:[NSData class]]||
        [self isKindOfClass:[NSError class]]||
        [NSStringFromClass(self.class) isEqualToString:@"NSObject"]
        ) {
        return nil;
    }
    else if([self isKindOfClass:[NSDictionary class]]){
        return (NSDictionary*)self;
    }
    for (NSInteger i=0; i<propertyArray.count; i++){
        NSString *key=propertyArray[i];
        id value=[self valueForKey:key];
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [NSString stringWithFormat:@"%@",value];
        }
        if ([value isKindOfClass:[NSString class]]){
            if ([value isEqualToString:@"(null)"]) {
                value = @"";
            }
            if (![value length]||!value){
                
            }else{
                if ([key isEqualToString:@"Id"]){
                    [mutableDictionary setObject:value forKey:@"id"];
                }else{
                    [mutableDictionary setObject:value forKey:key];
                }
            }
        }
        else if([value isKindOfClass:[NSArray class]]){
            if (![value count]){
                
            } else if ([[value firstObject] isKindOfClass:[NSString class]]) {
                [mutableDictionary setObject:value forKey:key];
            }else{
                NSMutableArray *mutableArray=[[NSMutableArray alloc] init];
                NSArray *array=value;
                for (NSInteger i=0; i<array.count; i++){
                    id object=array[i];
                    NSDictionary *dic =[object toDictionary];
                    if (dic) {
                        [mutableArray addObject:dic];
                    }else{
                    }
                }
                [mutableDictionary setObject:mutableArray forKey:key];
            }
        }else{
            if (!value){
                
            }else{
                NSDictionary  *dic=[value toDictionary];
                if (dic) {
                    [mutableDictionary setObject:dic forKey:key];
                }
                else{
                }
            }
        }
    }
    return mutableDictionary;
}
#pragma mark - 获取成员变量名
-(NSArray *)propertyArray{
    if ([self isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary*)self allKeys];
    } else {
        NSMutableArray *propertyArray=[[NSMutableArray alloc] init];
        unsigned int propsCount;
        objc_property_t *props = class_copyPropertyList([self class], &propsCount);
        for(int i = 0;i < propsCount; i++){
            objc_property_t  prop = props[i];
            NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
            [propertyArray addObject:propName];
        }
        free(props);
        return propertyArray;
    }
}

+(BOOL)isNumber:(NSString *)numberStirng{
    NSArray *arrayStr=@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"."];
    if (numberStirng.length>20){
        return NO;
    }
    for (NSInteger i=0; i<numberStirng.length; i++){
        NSString *str=[numberStirng substringWithRange:NSMakeRange(i, 1)];
        for (NSInteger j=0; j<arrayStr.count; j++){
            if ([str isEqualToString:arrayStr[j]]){
                break;
            }
            else if (j==arrayStr.count-1&&![str isEqualToString:[arrayStr lastObject]]){
                return NO;
            }
        }
    }
    return YES;
}
+(id)newObject:(id)object{
    NSString *class=NSStringFromClass([object class]);
    id object1= [[NSClassFromString(class) alloc] init];
    NSDictionary *dictionary=[object toDictionary];
    
    [object1 setValuesForKeysWithDictionary:dictionary];
    return object1;
}
+(NSString *)checkNil:(NSString *)value{
    if (!value) {
        return @"";
    }else{
        return value;
    }
}
-(NSDictionary *)dataModelDictionary{
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic=(NSDictionary *)self;
        if (dic[@"status"]&&dic[@"data"]&&dic[@"msg"]&&dic[@"code"]) {
            if ([dic[@"status"] integerValue]) {
                return dic[@"data"];
            }else{
                [Dialog toast:dic[@"msg"] delay:2.0f];
                return nil;
            }
        }else{
            return dic;
        }
    }else{
        return (NSDictionary *)self;
    }
    
}
@end
