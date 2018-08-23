//
//  PSDBModel.h
//  PSOksales
//
//  Created by tangbin on 2017/1/22.
//  Copyright © 2017年 tangbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSDBHelper.h"
/** SQLite五种数据类型 */
#define SQLTEXT     @"TEXT"
#define SQLINTEGER  @"INTEGER"
#define SQLREAL     @"REAL"
#define SQLBLOB     @"BLOB"
#define SQLNULL     @"NULL"

#define PrimaryKey  @"primary key"
#define primaryId   @"pk"

//#import "DXUserModel.h"



@interface PSDBModel : NSObject
/** 
 主键 id 
 */
@property (nonatomic, assign)   int        pk;
/** 
 列名
 */
@property (retain, readonly, nonatomic) NSMutableArray         *columeNames;
/** 
 列类型 
 */
@property (retain, readonly, nonatomic) NSMutableArray         *columeTypes;

/**
 *  获取该类的所有属性
 */
+ (NSDictionary *)getPropertys;

/** 
 获取所有属性，包括主键 
 */
+ (NSDictionary *)getAllProperties;

/** 
 数据库中是否存在表 
 */
+ (BOOL)isExistInTable;

/** 
 表中的字段
 */
+ (NSArray *)getColumns;

/** 保存或更新
 * 如果不存在主键，保存，
 * 有主键，则更新
 */
- (BOOL)saveOrUpdate;
/** 保存或更新
 * 如果根据特定的列数据可以获取记录，则更新，
 * 没有记录，则保存
 */
- (BOOL)saveOrUpdateByColumnName:(NSString*)columnName AndColumnValue:(NSString*)columnValue;
/** 
 保存单个数据 
 */
- (BOOL)save;
/** 
 批量保存数据 
 */
+ (BOOL)saveObjects:(NSArray *)array;
/**
 批量保存数据如果字段名为key的数据和 array的元素相同则先删除然后在存入array的元素
 */

+(BOOL)saveObjects:(NSArray *)array andNOtRepeatKey:(NSArray *)keys;

+(void)saveObjects:(NSArray *)array andNOtRepeatKey:(NSArray *)keys andResponseBlack:(ResponseBlack)responseBlack;
/**
 更新单个数据 
 */
- (BOOL)update;
/** 
 批量更新数据
 */
+ (BOOL)updateObjects:(NSArray *)array;
/** 
 删除单个数据 
 */
- (BOOL)deleteObject;
/** 
 批量删除数据 
 */
+ (BOOL)deleteObjects:(NSArray *)array;

/**
 批量删除数据keys的值为Model的属性名
 */
+ (BOOL)deleteObjects:(NSArray *)array andKeys:(NSArray *)keys;

/** 
 通过条件删除数据 
 */
+ (BOOL)deleteObjectsByCriteria:(NSString *)criteria;
/** 
 通过条件删除 (多参数）--2 
 */
+ (BOOL)deleteObjectsWithFormat:(NSString *)format, ...;
/** 
 清空表 
 */
+ (BOOL)clearTable;

/** 
 查询全部数据 
 */
+ (NSArray *)findAll;

/**
 通过条件模糊查询结果 如:通过客户Id,客户名称 多个条件查询
 
 @param criterias 多个查询条件 如 @[@"customId",@"customName"]
 @param keyWord 根据关键字查询
 @return 查询到的结果数组
 */
+ (NSArray *)findObjectsLikeWithCriterias:(NSArray *)criterias keyWord:(NSString *)keyWord;

/**
 根据搜索条件精确匹配  如 where customId = '00001'

 @param criteria 查询条件
 @param keyWord 搜索关键字
 @return 搜索到的结果
 */
+ (NSArray *)findObjectsEqualWithCriteria:(NSString *)criteria keyWord:(NSString *)keyWord;
/**
 通过主键查询 
 */
+ (instancetype)findByPK:(int)inPk;

+ (instancetype)findFirstWithFormat:(NSString *)format, ...;

/** 
 查找某条数据 
 */
+ (instancetype)findFirstByCriteria:(NSString *)criteria;

+ (NSArray *)findWithFormat:(NSString *)format, ...;

/** 通过条件查找数据
 * 这样可以进行分页查询 @" WHERE pk > 5 limit 10"
 */
+ (NSArray *)findByCriteria:(NSString *)criteria /*TBDeprecated("请使用 findObjectsLikeWithCriterias:keyWord / 或者 findObjectsEqualWithCriteria:keyWord 使用更简便") */;
/**
 * 创建表
 * 如果已经创建，返回YES
 */
+ (BOOL)createTable;

#pragma mark - must be override method
/** 
 如果子类中有一些property不需要创建数据库字段，那么这个方法必须在子类中重写
 */
+ (NSArray *)transients;
@end
