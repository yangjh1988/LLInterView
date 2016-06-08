//
//  LLDBManager.m
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import "LLDBManager.h"

#define SandDocPath()                 [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0]
#define CacheDocPath()                [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0]

#define DBPath                        [SandDocPath() stringByAppendingPathComponent:@"DB"]

static NSString * const kAdvId        = @"id";
static NSString * const kAdvTitle     = @"title";
static NSString * const kAdvUrl       = @"url";
static NSString * const kAdvCreatedAt = @"created_at";
static NSString * const kAdvUpdatedAt = @"updated_at";

@interface LLDBManager ()

@property (nonatomic, strong) FMDatabase *dataBase;

@end

@implementation LLDBManager

+ (LLDBManager *)shareInstance
{
    static LLDBManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialDatabase];
    }
    return self;
}

- (BOOL)initialDatabase
{
    if (!self.dataBase) {
        self.dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
        [self createAdvTable];
    }
    return YES;
}

- (void)DeleteDataBase
{
    NSString *dbpath = [self getDBPath];
    [[NSFileManager defaultManager] removeItemAtPath:dbpath error:nil];
    if (!self.dataBase) {
        self.dataBase = nil;
    }
    [self initialDatabase];
}

- (NSString *)getDBPath
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:DBPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:DBPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *path = [DBPath stringByAppendingPathComponent:@"lldb.sqlite"];
    return path;
}

- (NSString *)getAdvTableName
{
    return @"t_adv";
}

- (void)createAdvTable
{
    self.dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    if ([self.dataBase open]) {
        if (![self.dataBase tableExists:[self getAdvTableName]]) {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' \
                             ('%@' INTEGER KEY NOT NULL, \
                             '%@' TEXT NOT NULL, \
                             '%@' TEXT NOT NULL, \
                             '%@' TEXT NOT NULL, \
                             '%@' TEXT NOT NULL)",
                             [self getAdvTableName],
                             kAdvId,
                             kAdvTitle,
                             kAdvUrl,
                             kAdvCreatedAt,
                             kAdvUpdatedAt];
            [self.dataBase executeUpdate:sql];
            [self.dataBase close];
        }
    }
}

- (void)insertAdvData:(NSArray *)data
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getDBPath]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            if ([db open]) {
                BOOL deleteResult = [db executeUpdate:[NSString stringWithFormat:@"delete from %@",[self getAdvTableName]]];
                if (deleteResult) {
                    NSLog(@"delete data successed.");
                }
                for (LLAdvObject *adv in data) {
                    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ \
                                     ('%@', '%@', '%@', '%@', '%@') \
                                     VALUES (?,?,?,?,?)",
                                     [self getAdvTableName],
                                     kAdvId,
                                     kAdvTitle,
                                     kAdvUrl,
                                     kAdvCreatedAt,
                                     kAdvUpdatedAt];
                    BOOL result = [db executeUpdate:sql,
                                   [NSNumber numberWithInteger:adv._id],
                                   adv.title,
                                   adv.url,
                                   adv.created_at,
                                   adv.updated_at,nil];
                    if (!result) {
                        *rollback = YES;
                        return;
                    }
                }
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataBase close];
        });
    });
}

- (NSArray *)getAdvData
{
    NSMutableArray *dataArray = [NSMutableArray array];
    if ([self.dataBase open]) {
        __block NSMutableArray *dataArray = [NSMutableArray array];
        NSString *sql = [NSString stringWithFormat:@"select * from %@ \
                         where 1=1 order by %@ desc",
                         [self getAdvTableName],
                         kAdvId];
        FMResultSet *result = [self.dataBase executeQuery:sql];
        while ([result next]) {
            LLAdvObject *adv = [[LLAdvObject alloc] init];
            adv._id = [result intForColumn:kAdvId];
            adv.title = [result stringForColumn:kAdvTitle];
            adv.url = [result stringForColumn:kAdvUrl];
            adv.created_at = [result stringForColumn:kAdvCreatedAt];
            adv.updated_at = [result stringForColumn:kAdvUpdatedAt];
            [dataArray addObject:adv];
        }
        [self.dataBase close];
    }
    return dataArray;
}

- (void)deleteAdvWithId:(NSInteger)_id
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getDBPath]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            if ([db open]) {
                NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@=%zd",[self getAdvTableName],kAdvId,_id];
                BOOL result = [db executeUpdate:sql];
                if (!result) {
                    *rollback = YES;
                    return;
                }
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataBase close];
        });
    });
}

- (void)updateAdvWithId:(NSInteger)_id
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getDBPath]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            if ([db open]) {
                NSString *sql = [NSString stringWithFormat:@"update from %@ where %@=%zd",[self getAdvTableName],kAdvId,_id];
                BOOL result = [db executeUpdate:sql];
                if (!result) {
                    *rollback = YES;
                    return;
                }
                [db close];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataBase close];
        });
    });
}

- (void)insetAdvData:(LLAdvObject *)adv
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getDBPath]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            if ([db open]) {
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ \
                                 ('%@', '%@', '%@', '%@', '%@') \
                                 VALUES (?,?,?,?,?)",
                                 [self getAdvTableName],
                                 kAdvId,
                                 kAdvTitle,
                                 kAdvUrl,
                                 kAdvCreatedAt,
                                 kAdvUpdatedAt];
                BOOL result= [db executeUpdate:sql,
                              [NSNumber numberWithInteger:adv._id],
                              adv.title,
                              adv.url,
                              adv.created_at,
                              adv.updated_at];
                if (!result) {
                    *rollback = YES;
                    return;
                }
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataBase close];
        });
    });
}

- (LLAdvObject *)getAdvWithId:(NSInteger)_id
{
    if ([self.dataBase open]) {
        LLAdvObject *adv = [[LLAdvObject alloc] init];
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@=%zd",
                         [self getAdvTableName],
                         kAdvId,
                         _id];
        FMResultSet *result = [self.dataBase executeQuery:sql];
        while ([result next]) {
            adv._id = [result intForColumn:kAdvId];
            adv.title = [result stringForColumn:kAdvTitle];
            adv.url = [result stringForColumn:kAdvUrl];
            adv.created_at = [result stringForColumn:kAdvCreatedAt];
            adv.updated_at = [result stringForColumn:kAdvUpdatedAt];
        }
        [self.dataBase close];
        return adv;
    }
    return nil;
}

@end
