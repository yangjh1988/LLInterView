//
//  LLNetworkManager.h
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "LLNetworkObjects.h"

typedef void (^ResponseObjectBlock)(LLNetworkBaseResult *responseObj);
typedef void (^FailureBlock)(NSURLSessionDataTask *operation, NSError *error);
typedef void (^ProgessBlock)(NSProgress *progess);;

@interface LLNetworkManager : AFHTTPSessionManager

+ (id)createNetworkManager;
+ (void)destroyManager;

- (void)getAdvListWith:(LLGetAdvListRequest *)request
         completeBlock:(ResponseObjectBlock)completeBlock
          failureBlock:(FailureBlock)failureBlock;

- (void)getAdvDetailWith:(LLGetAdvDetailRequest *)request
           completeBlock:(ResponseObjectBlock)completeBlock
            failureBlock:(FailureBlock)failureBlock;

- (void)updateAdvWith:(LLUpdateAdvRequest *)request
        completeBlock:(ResponseObjectBlock)completeBlock
         failureBlock:(FailureBlock)failureBlock;

- (void)addAdvWith:(LLAddAdvRequest *)request
     completeBlock:(ResponseObjectBlock)completeBlock
      failureBlock:(FailureBlock)failureBlock;

- (void)deleteAdvWith:(LLDeleteAdvRequest *)request
        completeBlock:(ResponseObjectBlock)completeBlock
         failureBlock:(FailureBlock)failureBlock;

@end
