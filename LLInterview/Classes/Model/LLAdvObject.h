//
//  LLAdvObject.h
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import "LLBaseObject.h"

@interface LLAdvObject : LLBaseObject

@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, copy  ) NSString  *url;
@property (nonatomic, copy  ) NSString  *title;
@property (nonatomic, copy  ) NSString  *created_at;
@property (nonatomic, copy  ) NSString  *updated_at;

@end

@interface LLAdvDetailObject : LLAdvObject

@end