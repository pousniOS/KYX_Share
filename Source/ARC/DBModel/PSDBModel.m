//
//  PSDBModel.m
//  PSOksales
//
//  Created by tangbin on 2017/1/22.
//  Copyright © 2017年 tangbin. All rights reserved.
//

#import "PSDBModel.h"
#import <objc/runtime.h>


@implementation PSDBModel

#pragma mark - override method
+ (void)initialize
{
    if (self != [PSDBModel self]) {
        if (![PSDBHelper shareInstance].notCreateTable) {
            [self createTable];
        }
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *dic = [self.class getAllProperties];
        _columeNames = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"name"]];
        _columeTypes = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"type"]];
    }
    return self;
}

#pragma mark - base method
/**
 *  获取该类的所有属性
 */
+ (NSDictionary *)getPropertys
{
    NSMutableArray *proNames = [NSMutableArray array];
    NSMutableArray *proTypes = [NSMutableArray array];
    NSArray *theTransients = [[self class] transients];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        //获取属性名
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if ([theTransients containsObject:propertyName]) {
            continue;
        }
        [proNames addObject:propertyName];
        //获取属性类型等参数
        NSString *propertyType = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
        /*
         各种符号对应类型，部分类型在新版SDK中有所变化，如long 和long long
         c char         C unsigned char
         i int          I unsigned int
         l long         L unsigned long
         s short        S unsigned short
         d double       D unsigned double
         f float        F unsigned float
         q long long    Q unsigned long long
         B BOOL
         @ 对象类型 //指针 对象类型 如NSString 是@“NSString”
         
         
         64位下long 和long long 都是Tq
         SQLite 默认支持五种数据类型TEXT、INTEGER、REAL、BLOB、NULL
         因为在项目中用的类型不多，故只考虑了少数类型
         */
        if ([propertyType hasPrefix:@"T@\"NSString\""]) {
            [proTypes addObject:SQLTEXT];
        } else if ([propertyType hasPrefix:@"T@\"NSData\""]) {
            [proTypes addObject:SQLBLOB];
        } else if ([propertyType hasPrefix:@"Ti"]||[propertyType hasPrefix:@"TI"]||[propertyType hasPrefix:@"Ts"]||[propertyType hasPrefix:@"TS"]||[propertyType hasPrefix:@"TB"]||[propertyType hasPrefix:@"Tq"]||[propertyType hasPrefix:@"TQ"]) {
            [proTypes addObject:SQLINTEGER];
        } else {
            [proTypes addObject:SQLREAL];
        }
        
    }
    free(properties);
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",nil];
}

/** 获取所有属性，包含主键pk */
+ (NSDictionary *)getAllProperties
{
    NSDictionary *dict = [self.class getPropertys];
    
    NSMutableArray *proNames = [NSMutableArray array];
    NSMutableArray *proTypes = [NSMutableArray array];
    [proNames addObject:primaryId];
    [proTypes addObject:[NSString stringWithFormat:@"%@ %@",SQLINTEGER,PrimaryKey]];
    [proNames addObjectsFromArray:[dict objectForKey:@"name"]];
    [proTypes addObjectsFromArray:[dict objectForKey:@"type"]];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",nil];
}
/** 数据库中是否存在表 */
+ (BOOL)isExistInTable
{
    __block BOOL res = NO;
    PSDBHelper *psDB = [PSDBHelper shareInstance];
    [psDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        res = [db tableExists:tableName];
    }];
    return res;
}

/** 获取列名 */
+ (NSArray *)getColumns
{
    PSDBHelper *psDB = [PSDBHelper shareInstance];
    NSMutableArray *columns = [NSMutableArray array];
    [psDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        FMResultSet *resultSet = [db getTableSchema:tableName];
        while ([resultSet next]) {
            NSString *column = [resultSet stringForColumn:@"name"];
            [columns addObject:column];
        }
    }];
    return [columns copy];
}

/**
 * 创建表
 * 如果已经创建，返回YES
 */
+ (BOOL)createTable
{
    __block BOOL res = YES;
    PSDBHelper *psDB = [PSDBHelper shareInstance];
    [psDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *columeAndType = [self.class getColumeAndTypeString];
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@);",tableName,columeAndType];
        if (![db executeUpdate:sql]) {
            res = NO;
            *rollback = YES;
            return;
        };
        
        NSMutableArray *columns = [NSMutableArray array];
        FMResultSet *resultSet = [db getTableSchema:tableName];
        while ([resultSet next]) {
            NSString *column = [resultSet stringForColumn:@"name"];
            [columns addObject:column];
        }
        NSDictionary *dict = [self.class getAllProperties];
        NSArray *properties = [dict objectForKey:@"name"];
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",columns];
        //过滤数组
        NSArray *resultArray = [properties filteredArrayUsingPredicate:filterPredicate];
        for (NSString *column in resultArray) {
            NSUInteger index = [properties indexOfObject:column];
            NSString *proType = [[dict objectForKey:@"type"] objectAtIndex:index];
            NSString *fieldSql = [NSString stringWithFormat:@"%@ %@",column,proType];
            NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ ",NSStringFromClass(self.class),fieldSql];
            if (![db executeUpdate:sql]) {
                res = NO;
                *rollback = YES;
                return ;
            }
        }
    }];
    return res;
}

- (BOOL)saveOrUpdate
{
    id primaryValue = [self valueForKey:primaryId];
    if ([primaryValue intValue] <= 0) {
        return [self save];
    }
    return [self update];
}

- (BOOL)saveOrUpdateByColumnName:(NSString*)columnName AndColumnValue:(NSString*)columnValue
{
    id record = [self.class findFirstByCriteria:[NSString stringWithFormat:@"where %@ = %@",columnName,columnValue]];
    if (record) {
        id primaryValue = [record valueForKey:primaryId]; //取到了主键PK
        if ([primaryValue intValue] <= 0) {
            return [self save];
        }else{
            self.pk = [primaryValue intValue];
            return [self update];
        }
    }else{
        return [self save];
    }
}
- (BOOL)save
{
    NSString *tableName = NSStringFromClass(self.class);
    NSMutableString *keyString = [NSMutableString string];
    NSMutableString *valueString = [NSMutableString string];
    NSMutableArray *insertValues = [NSMutableArray  array];
    for (int i = 0; i < self.columeNames.count; i++) {
        NSString *proname = [self.columeNames objectAtIndex:i];
        if ([proname isEqualToString:primaryId]) {
            continue;
        }
        [keyString appendFormat:@"%@,", proname];
        [valueString appendString:@"?,"];
        id value = [self valueForKey:proname];
        if (!value) {
            value = @"";
        }
        [insertValues addObject:value];
    }
    [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
    [valueString deleteCharactersInRange:NSMakeRange(valueString.length - 1, 1)];
    
    PSDBHelper *psDB = [PSDBHelper shareInstance];
    __block BOOL res = NO;
    [psDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@);", tableName, keyString, valueString];
        res = [db executeUpdate:sql withArgumentsInArray:insertValues];
        self.pk = res?[NSNumber numberWithLongLong:db.lastInsertRowId].intValue:0;
    }];
    [psDB.dbQueue close];
    return res;
}
+(BOOL)saveObjects:(NSArray *)array andNOtRepeatKey:(NSArray *)keys{
//    //判断是否是psBaseModel的子类
//    for (PSDBModel *model in array) {
//        if (![model isKindOfClass:[PSDBModel class]]) {
//            return NO;
//        }
//    }

    
    __block BOOL res = YES;
    PSDBHelper *psDB = [PSDBHelper shareInstance];
    // 如果要支持事务
    [psDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        res=[self insertIntoValues:array andNOtRepeatKey:keys andDB:db];
        *rollback=YES;
//        for (PSDBModel *model in array) {
//            if (![model isKindOfClass:[PSDBModel class]]) {
//                res = NO;
//                *rollback = YES;
//                return ;
//            }
//
//            NSString *tableName = NSStringFromClass(model.class);
//            NSMutableString *keyString = [NSMutableString string];
//            NSMutableString *valueString = [NSMutableString string];
//            NSMutableArray *insertValues = [NSMutableArray  array];
//            for (int i = 0; i < model.columeNames.count; i++) {
//                NSString *proname = [model.columeNames objectAtIndex:i];
//                if ([proname isEqualToString:primaryId]) {
//                    continue;
//                }
//                [keyString appendFormat:@"%@,", proname];
//                [valueString appendString:@"?,"];
//                id value = [model valueForKey:proname];
//                if (!value) {
//                    value = @"";
//                }
//                [insertValues addObject:value];
//            }
//            [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
//            [valueString deleteCharactersInRange:NSMakeRange(valueString.length - 1, 1)];
//
//            if (keys.count) {//删除重复的数据
//                NSMutableArray *queryArray=[[NSMutableArray alloc] init];
//                [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    NSString *value=[model valueForKey:obj];
//                    [queryArray addObject:[NSString stringWithFormat:@"%@='%@'",obj,value]];
//                }];
//                NSString *sql=[NSString stringWithFormat:@"delete from %@ where %@",tableName,[queryArray componentsJoinedByString:@" and "]];
//                [db executeUpdate:sql];
//            }
//
//            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@);", tableName, keyString, valueString];
//            BOOL flag = [db executeUpdate:sql withArgumentsInArray:insertValues];
//            model.pk = flag?[NSNumber numberWithLongLong:db.lastInsertRowId].intValue:0;
//
//            if (!flag) {
//                res = NO;
//                *rollback = YES;
//                return;
//            }
//        }
    }];
    return res;
}

+(void)saveObjects:(NSArray *)array andNOtRepeatKey:(NSArray *)keys andResponseBlack:(ResponseBlack)responseBlack{
    
//    dispatch_queue_t queue = dispatch_queue_create("tk.bourne.testQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue = dispatch_queue_create("DB.insertIntoValues", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        FMDatabase *db=[FMDatabase databaseWithPath:[PSDBHelper dbPath]];
        if (![db open]) {
//            NSLog(@"数据库打开失败");
            responseBlack(self,@NO);
            return ;
        }
        [self insertIntoValues:array andNOtRepeatKey:keys andDB:db];
        if (![db close]) {
//            NSLog(@"数据库关闭失败");
            responseBlack(self,@NO);
            return ;
        }
        responseBlack(self,@YES);
    });
}



/**数据插入数据库**/
+(BOOL )insertIntoValues:(NSArray *)values andNOtRepeatKey:(NSArray *)keys andDB:(FMDatabase *)db{
    BOOL result=YES;
    for (PSDBModel *model in values) {
        if (![model isKindOfClass:[PSDBModel class]]) {
            result = NO;
        }
        
        NSString *tableName = NSStringFromClass(model.class);
        NSMutableString *keyString = [NSMutableString string];
        NSMutableString *valueString = [NSMutableString string];
        NSMutableArray *insertValues = [NSMutableArray  array];
        for (int i = 0; i < model.columeNames.count; i++) {
            NSString *proname = [model.columeNames objectAtIndex:i];
            if ([proname isEqualToString:primaryId]) {
                continue;
            }
            [keyString appendFormat:@"%@,", proname];
            [valueString appendString:@"?,"];
            id value = [model valueForKey:proname];
            if (!value) {
                value = @"";
            }
            [insertValues addObject:value];
        }
        [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
        [valueString deleteCharactersInRange:NSMakeRange(valueString.length - 1, 1)];
        
        if (keys.count) {//删除重复的数据
            NSMutableArray *queryArray=[[NSMutableArray alloc] init];
            [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *value=[model valueForKey:obj];
                [queryArray addObject:[NSString stringWithFormat:@"%@='%@'",obj,value]];
            }];
            NSString *sql=[NSString stringWithFormat:@"delete from %@ where %@",tableName,[queryArray componentsJoinedByString:@" and "]];
            [db executeUpdate:sql];
        }
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@);", tableName, keyString, valueString];
        BOOL flag = [db executeUpdate:sql withArgumentsInArray:insertValues];
        model.pk = flag?[NSNumber numberWithLongLong:db.lastInsertRowId].intValue:0;

        result=flag;
    }
    return result;
}


/** 批量保存用户对象 */
+ (BOOL)saveObjects:(NSArray *)array
{
    return [self saveObjects:array andNOtRepeatKey:nil];
}
/** 更新单个对象 */
- (BOOL)update
{
    PSDBHelper *psDB = [PSDBHelper shareInstance];
    __block BOOL res = NO;
    [psDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        id primaryValue = [self valueForKey:primaryId];
        if (!primaryValue || primaryValue <= 0) {
            return ;
        }
        NSMutableString *keyString = [NSMutableString string];
        NSMutableArray *updateValues = [NSMutableArray  array];
        for (int i = 0; i < self.columeNames.count; i++) {
            NSString *proname = [self.columeNames objectAtIndex:i];
            if ([proname isEqualToString:primaryId]) {
                continue;
            }
            [keyString appendFormat:@" %@=?,", proname];
            id value = [self valueForKey:proname];
            if (!value) {
                value = @"";
            }
            [updateValues addObject:value];
        }
        
        //删除最后那个逗号
        [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = ?;", tableName, keyString, primaryId];
        [updateValues addObject:primaryValue];
        res = [db executeUpdate:sql withArgumentsInArray:updateValues];

    }];
    [psDB.dbQueue close];
    return res;
}

/** 批量更新用户对象*/
+ (BOOL)updateObjects:(NSArray *)array
{
    for (PSDBModel *model in array) {
        if (![model isKindOfClass:[PSDBModel class]]) {
            return NO;
        }
    }
    __block BOOL res = YES;
    PSDBHelper *psDB = [PSDBHelper shareInstance];
    // 如果要支持事务
    [psDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (PSDBModel *model in array) {
            NSString *tableName = NSStringFromClass(model.class);
            id primaryValue = [model valueForKey:primaryId];
            if (!primaryValue || primaryValue <= 0) {
                res = NO;
                *rollback = YES;
                return;
            }
            
            NSMutableString *keyString = [NSMutableString string];
            NSMutableArray *updateValues = [NSMutableArray  array];
            for (int i = 0; i < model.columeNames.count; i++) {
                NSString *proname = [model.columeNames objectAtIndex:i];
                if ([proname isEqualToString:primaryId]) {
                    continue;
                }
                [keyString appendFormat:@" %@=?,", proname];
                id value = [model valueForKey:proname];
                if (!value) {
                    value = @"";
                }
                [updateValues addObject:value];
            }
            
            //删除最后那个逗号
            [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@=?;", tableName, keyString, primaryId];
            [updateValues addObject:primaryValue];
            BOOL flag = [db executeUpdate:sql withArgumentsInArray:updateValues];

            if (!flag) {
                res = NO;
                *rollback = YES;
                return;
            }
        }
    }];
    
    return res;
}

/** 删除单个对象 */
- (BOOL)deleteObject
{
    PSDBHelper *psDB = [PSDBHelper shareInstance];
    __block BOOL res = NO;
    [psDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        id primaryValue = [self valueForKey:primaryId];
        if (!primaryValue || primaryValue <= 0) {
            return ;
        }
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",tableName,primaryId];
        res = [db executeUpdate:sql withArgumentsInArray:@[primaryValue]];
        
    }];
    return res;
}

/** 批量删除用户对象 */
+ (BOOL)deleteObjects:(NSArray *)array
{
    for (PSDBModel *model in array) {
        if (![model isKindOfClass:[PSDBModel class]]) {
            return NO;
        }
    }
    
    __block BOOL res = YES;
    PSDBHelper *psDB = [PSDBHelper shareInstance];
    // 如果要支持事务
    [psDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (PSDBModel *model in array) {
            NSString *tableName = NSStringFromClass(model.class);
            id primaryValue = [model valueForKey:primaryId];
            if (!primaryValue || primaryValue <= 0) {
                return ;
            }
            
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",tableName,primaryId];
            BOOL flag = [db executeUpdate:sql withArgumentsInArray:@[primaryValue]];
            if (!flag) {
                res = NO;
                *rollback = YES;
                return;
            }
        }
    }];
    return res;
}

+ (BOOL)deleteObjects:(NSArray *)array andKeys:(NSArray *)keys{
    for (PSDBModel *model in array) {
        if (![model isKindOfClass:[PSDBModel class]]) {
            return NO;
        }
    }
    __block BOOL res = YES;

    if (!keys.count) {
        return res;
    }
    PSDBHelper *psDB = [PSDBHelper shareInstance];
    // 如果要支持事务
    [psDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (PSDBModel *model in array) {
            NSString *tableName = NSStringFromClass(model.class);
            NSMutableArray *queryArray=[[NSMutableArray alloc] init];
            [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *value=[model valueForKey:obj];
                [queryArray addObject:[NSString stringWithFormat:@"%@='%@'",obj,value]];
            }];
            NSString *sql= sql=[NSString stringWithFormat:@"delete from %@ where %@",tableName,[queryArray componentsJoinedByString:@" and "]];
            BOOL flag=[db executeUpdate:sql];
            if (!flag) {
                res = NO;
                *rollback = YES;
                return;
            }
        }
    }];
    return res;
}

/** 通过条件删除数据 */
+ (BOOL)deleteObjectsByCriteria:(NSString *)criteria
{
    PSDBHelper *psDB = [PSDBHelper shareInstance];
    __block BOOL res = NO;
    [psDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@ ",tableName,criteria];
        res = [db executeUpdate:sql];
        
    }];
    return res;
}
/** 通过条件删除 (多参数）--2 */
+ (BOOL)deleteObjectsWithFormat:(NSString *)format, ...
{
    va_list ap;
    va_start(ap, format);
    NSString *criteria = [[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:ap];
    va_end(ap);
    
    return [self deleteObjectsByCriteria:criteria];
}

/** 清空表 */
+ (BOOL)clearTable
{
    PSDBHelper *psDB = [PSDBHelper shareInstance];
    __block BOOL res = NO;
    [psDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
        res = [db executeUpdate:sql];
    }];
    return res;
}

/** 查询全部数据 */
+ (NSArray *)findAll
{
    PSDBHelper *psDB = [PSDBHelper shareInstance];
    NSMutableArray *users = [NSMutableArray array];
    [psDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            PSDBModel *model = [[self.class alloc] init];
            for (int i=0; i< model.columeNames.count; i++) {
                NSString *columeName = [model.columeNames objectAtIndex:i];
                NSString *columeType = [model.columeTypes objectAtIndex:i];
                if ([columeType isEqualToString:SQLTEXT]) {
                    [model setValue:[resultSet stringForColumn:columeName] forKey:columeName];
                } else if ([columeType isEqualToString:SQLBLOB]) {
                    [model setValue:[resultSet dataForColumn:columeName] forKey:columeName];
                } else {
                    [model setValue:[NSNumber numberWithLongLong:[resultSet longLongIntForColumn:columeName]] forKey:columeName];
                }
            }
            [users addObject:model];
            FMDBRelease(model);
        }
    }];
    [psDB.dbQueue close];
    return users;
}

+ (instancetype)findFirstWithFormat:(NSString *)format, ...
{
    va_list ap;
    va_start(ap, format);
    NSString *criteria = [[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:ap];
    va_end(ap);
    
    return [self findFirstByCriteria:criteria];
}

/** 查找某条数据 */
+ (instancetype)findFirstByCriteria:(NSString *)criteria
{
    NSArray *results = [self.class findByCriteria:criteria];
    if (results.count < 1) {
        return nil;
    }
    
    return [results firstObject];
}

+ (instancetype)findByPK:(int)inPk
{
    NSString *condition = [NSString stringWithFormat:@"WHERE %@=%d",primaryId,inPk];
    return [self findFirstByCriteria:condition];
}

+ (NSArray *)findWithFormat:(NSString *)format, ...
{
    va_list ap;
    va_start(ap, format);
    NSString *criteria = [[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:ap];
    va_end(ap);
    
    return [self findByCriteria:criteria];
}
/** 通过条件查找数据 */
+ (NSArray *)findByCriteria:(NSString *)criteria
{
    PSDBHelper *psDB = [PSDBHelper shareInstance];
    NSMutableArray *users = [NSMutableArray array];
    [psDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@",tableName,criteria];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            PSDBModel *model = [[self.class alloc] init];
            for (int i=0; i< model.columeNames.count; i++) {
                NSString *columeName = [model.columeNames objectAtIndex:i];
                NSString *columeType = [model.columeTypes objectAtIndex:i];
                if ([columeType isEqualToString:SQLTEXT]) {
                    [model setValue:[resultSet stringForColumn:columeName] forKey:columeName];
                } else if ([columeType isEqualToString:SQLBLOB]) {
                    [model setValue:[resultSet dataForColumn:columeName] forKey:columeName];
                } else {
                    [model setValue:[NSNumber numberWithLongLong:[resultSet longLongIntForColumn:columeName]] forKey:columeName];
                }
            }
            [users addObject:model];
            FMDBRelease(model);
        }
    }];
    return users;
}

+ (NSArray *)findObjectsLikeWithCriterias:(NSArray *)criterias keyWord:(NSString *)keyWord {
    
    NSMutableArray *tempCriterias = [NSMutableArray array];
    for (NSString *criteria in criterias) {
        NSString *tempStr = [NSString stringWithFormat:@"%@ like '%%%@%%'",criteria,keyWord];
        [tempCriterias addObject:tempStr];
    }
    NSString *condition = [NSString stringWithFormat:@"where %@",[tempCriterias componentsJoinedByString:@" OR "]];
    return [self findByCriteria:condition];
}

+ (NSArray *)findObjectsEqualWithCriteria:(NSString *)criteria keyWord:(NSString *)keyWord {
    NSString *conditon = [NSString stringWithFormat:@"WHERE %@ = '%@'",criteria,keyWord];
    return [self findByCriteria:conditon];
}

#pragma mark - util method
+ (NSString *)getColumeAndTypeString
{
    NSMutableString* pars = [NSMutableString string];
    NSDictionary *dict = [self.class getAllProperties];
    
    NSMutableArray *proNames = [dict objectForKey:@"name"];
    NSMutableArray *proTypes = [dict objectForKey:@"type"];
    
    for (int i=0; i< proNames.count; i++) {
        [pars appendFormat:@"%@ %@",[proNames objectAtIndex:i],[proTypes objectAtIndex:i]];
        if(i+1 != proNames.count)
        {
            [pars appendString:@","];
        }
    }
    return pars;
}

//- (NSString *)description
//{
//    NSString *result = NSStringFromClass(self.class);
//    NSDictionary *dict = [self.class getAllProperties];
//    NSMutableArray *proNames = [dict objectForKey:@"name"];
//    for (int i = 0; i < proNames.count; i++) {
//        NSString *proName = [proNames objectAtIndex:i];
//        id  proValue = [self valueForKey:proName];
//        result = [result stringByAppendingFormat:@"%@:%@\n",proName,proValue];
//    }
//    
//    return result;
//}
#pragma mark - must be override method
/** 如果子类中有一些property不需要创建数据库字段，那么这个方法必须在子类中重写
 */
+ (NSArray *)transients
{
    return [NSArray array];
}
@end
