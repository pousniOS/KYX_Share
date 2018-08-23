//
//  PSDBHelper.h
//  PSOksales
//
//  Created by tangbin on 2017/1/22.
//  Copyright © 2017年 tangbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface PSDBHelper : NSObject
@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

@property (nonatomic, assign) BOOL notCreateTable;



+ (PSDBHelper *)shareInstance;



+ (NSString *)dbPath;

- (BOOL)changeDBWithDirectoryName:(NSString *)directoryName;
@end
