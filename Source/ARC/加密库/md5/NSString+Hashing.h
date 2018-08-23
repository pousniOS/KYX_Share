

#import <Foundation/Foundation.h>


@interface NSString (NSString_Hashing)

- (NSString *)MD5Hash;
#pragma mark - 32位 小写
+(NSString *)MD5ForLower32Bate:(NSString *)str;
@end
