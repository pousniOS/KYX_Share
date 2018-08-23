//
//  NSData +Encryption.h
//  加密算法1111
//
//  Created by posun on 15/11/9.
//  Copyright © 2015年 posun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(Encryption)
- (NSData *)AES256EncryptWithKey:(NSData *)key;   //加密

- (NSData *)AES256DecryptWithKey:(NSData *)key;   //解密

- (NSString *)newStringInBase64FromData;            //追加64编码

+ (NSString*)base64encode:(NSString*)str;           //同上64编码

+(NSData*)stringToByte:(NSString*)string;

+(NSString*)byteToString:(NSData*)data;
@end
