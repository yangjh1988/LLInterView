//
//  LLNetworkBaseRequest.h
//  
//
//  Created by Jiahong on 16/6/8.
//
//

#import <Foundation/Foundation.h>
#import "LLObjects.h"

@interface LLNetworkObjects : NSObject

@end

@interface LLNetworkBaseRequest : NSObject

@end

@interface LLNetworkBaseResult : NSObject

@end

@interface LLGetAdvListRequest : LLNetworkBaseRequest

@end

@interface LLGetAdvListResult : LLNetworkBaseResult

@property (nonatomic, strong) NSArray *adv_list;

@end

@interface LLGetAdvDetailRequest : LLNetworkBaseRequest

@property (nonatomic, assign) NSInteger _id;

@end

@interface LLGetAdvDetailResult : LLNetworkBaseResult

@property (nonatomic, strong) LLAdvObject *adv;

@end

@interface LLUpdateAdvRequest : LLNetworkBaseRequest

@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, copy  ) NSString  *url;
@property (nonatomic, copy  ) NSString  *title;

@end

@interface LLUpdateAdvResult : LLNetworkBaseResult

@end

@interface LLAddAdvRequest : LLNetworkBaseRequest

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;

@end

@interface LLAddAdvResult : LLNetworkBaseResult

@property (nonatomic, strong) LLAdvObject *adv;

@end

@interface LLDeleteAdvRequest : LLNetworkBaseRequest

@property (nonatomic, assign) NSInteger _id;

@end

@interface LLDeleteAdvResult : LLNetworkBaseResult

@end