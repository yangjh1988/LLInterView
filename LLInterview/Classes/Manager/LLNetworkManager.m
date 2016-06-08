//
//  LLNetworkManager.m
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import "LLNetworkManager.h"
#import "LLAdvObject.h"

static LLNetworkManager *nwManager;

static NSString * const kGetAdvListPath = @"/adv";
static NSString * const kGetAdvDetailPath = @"/adv";
static NSString * const kUpdateAdvPath = @"/adv";
static NSString * const kAddAdvPath = @"/adv";
static NSString * const kDeleteAdvPath = @"/adv";

@implementation LLNetworkManager

+ (id)createNetworkManager
{
    @synchronized(self) {
        if (nil == nwManager) {
            nwManager = [LLNetworkManager manager];
        }
    }
    return nwManager;
}

+ (void)destroyManager
{
    @synchronized(self) {
        if (nwManager) {
            nwManager = nil;
        }
    }
}

- (NSString *)getUrlWith:(NSString *)path
{
    NSString *hostName = @"http://120.132.56.199:3081";
    return [NSString stringWithFormat:@"%@%@",hostName,path];
}

- (NSString *)getUrlWithPath:(NSString *)path _id:(NSInteger)_id
{
    return [NSString stringWithFormat:@"%@/%zd",[self getUrlWith:path],_id];
}

#pragma mark -- requests --
- (void)getAdvListWith:(LLGetAdvListRequest *)request
         completeBlock:(ResponseObjectBlock)completeBlock
          failureBlock:(FailureBlock)failureBlock
{
    NSString *url = [self getUrlWith:kGetAdvListPath];
    
    [self  GET:url
    parameters:nil
      progress:^(NSProgress * _Nonnull uploadProgress) {
          
    }
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           if (completeBlock) {
               NSArray *array = (NSArray *)responseObject;
               NSLog(@"get adv list array = %@",array);
               LLGetAdvListResult *result = [[LLGetAdvListResult alloc] init];
               NSMutableArray *adv_list = [NSMutableArray array];
               for (NSDictionary *dataDict in array) {
                   LLAdvObject *advObj = [[LLAdvObject alloc] init];
                   advObj._id = [[dataDict objectForKey:@"id"] longValue];
                   advObj.url = [dataDict objectForKey:@"url"];
                   advObj.title = [dataDict objectForKey:@"title"];
                   advObj.created_at = [dataDict objectForKey:@"created_at"];
                   advObj.updated_at = [dataDict objectForKey:@"updated_at"];
                   [adv_list addObject:advObj];
               }
               result.adv_list = adv_list;
               completeBlock(result);
           }
    }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           if (failureBlock) {
               failureBlock(task,error);
           }
    }];
}

- (void)getAdvDetailWith:(LLGetAdvDetailRequest *)request
           completeBlock:(ResponseObjectBlock)completeBlock
            failureBlock:(FailureBlock)failureBlock
{
    NSString *url = [self getUrlWithPath:kGetAdvDetailPath _id:request._id];
    
    [self  GET:url
    parameters:nil
      progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSDictionary *dict = (NSDictionary *)responseObject;
           NSLog(@"adv detail dict = %@",dict);
           LLGetAdvDetailResult *result = [[LLGetAdvDetailResult alloc] init];
           LLAdvObject *adv = [[LLAdvObject alloc] init];
           adv._id = [[dict objectForKey:@"id"] longValue];
           adv.title = [dict objectForKey:@"title"];
           adv.url = [dict objectForKey:@"url"];
           adv.created_at = [dict objectForKey:@"created_at"];
           adv.updated_at = [dict objectForKey:@"updated_at"];
           result.adv = adv;
           if (completeBlock) {
               completeBlock(result);
           }
    }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           if (failureBlock) {
               failureBlock(task,error);
           }
    }];
}

- (void)updateAdvWith:(LLUpdateAdvRequest *)request
        completeBlock:(ResponseObjectBlock)completeBlock
         failureBlock:(FailureBlock)failureBlock
{
    NSString *url = [self getUrlWithPath:kUpdateAdvPath _id:request._id];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (request.title) {
        [param setObject:request.title forKey:@"title"];
    }
    if (request.url) {
        [param setObject:request.url forKey:@"url"];
    }
    
    [self PUT:url
   parameters:param
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          if (completeBlock) {
              NSDictionary *dict = (NSDictionary *)responseObject;
              NSLog(@"update adv dict = %@",dict);
              LLUpdateAdvResult *result = [[LLUpdateAdvResult alloc] init];
              completeBlock(result);
          }
    }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          if (failureBlock) {
              failureBlock(task,error);
          }
    }];
}

- (void)addAdvWith:(LLAddAdvRequest *)request
     completeBlock:(ResponseObjectBlock)completeBlock
      failureBlock:(FailureBlock)failureBlock
{
    NSString *url = [self getUrlWith:kAddAdvPath];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSAssert(request.url, @"");
    NSAssert(request.title, @"");
    [param setObject:request.title forKey:@"title"];
    [param setObject:request.url forKey:@"url"];
    
    [self POST:url
    parameters:param
      progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           if (completeBlock) {
               NSDictionary *dict = (NSDictionary *)responseObject;
               NSLog(@"add adv dict = %@",dict);
               LLAddAdvResult *result = [[LLAddAdvResult alloc] init];
               LLAdvObject *adv = [[LLAdvObject alloc] init];
               adv._id = [[dict objectForKey:@"id"] integerValue];
               adv.title = [dict objectForKey:@"title"];
               adv.url = [dict objectForKey:@"url"];
               adv.created_at = [dict objectForKey:@"created_at"];
               adv.updated_at = [dict objectForKey:@"updated_at"];
               result.adv = adv;
               completeBlock(result);
           }
    }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           if (failureBlock) {
               failureBlock(task,error);
           }
    }];
}

- (void)deleteAdvWith:(LLDeleteAdvRequest *)request
        completeBlock:(ResponseObjectBlock)completeBlock
         failureBlock:(FailureBlock)failureBlock
{
    NSString *url = [self getUrlWithPath:kDeleteAdvPath _id:request._id];
    
    [self DELETE:url
      parameters:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *dict = (NSDictionary *)responseObject;
             NSLog(@"delete adv dict = %@",dict);
             LLDeleteAdvResult *result = [[LLDeleteAdvResult alloc] init];
             if (completeBlock) {
                 completeBlock(result);
             }
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (failureBlock) {
                 failureBlock(task,error);
             }
    }];
}

@end
