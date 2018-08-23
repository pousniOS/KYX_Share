//
//  NSData+AES256.h
//  AES加密库
//
//  Created by iJeff on 15/8/20.
//  Copyright (c) 2015年 iJeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (AES256)

-(NSData *) aes256_encrypt:(NSString *)key;
-(NSData *) aes256_decrypt:(NSString *)key;

@end
