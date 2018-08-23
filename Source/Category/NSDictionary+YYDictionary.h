//
//  DicToJson(NSString).h
//  fossil-ipad
//
//  Created by POSUN-MAC on 15/11/18.
//  Copyright © 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(YYDictionary)
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
