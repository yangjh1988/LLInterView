//
//  LLDBManager.h
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import <FMDB/FMDB.h>
#import "LLObjects.h"

@interface LLDBManager : NSObject

+ (LLDBManager *)shareInstance;

- (void)DeleteDataBase;

- (void)insertAdvData:(NSArray *)data;
- (NSArray *)getAdvData;
- (void)deleteAdvWithId:(NSInteger)_id;
- (void)updateAdvWithId:(NSInteger)_id;
- (void)insetAdvData:(LLAdvObject *)adv;
- (LLAdvObject *)getAdvWithId:(NSInteger)_id;

@end
