//
//  LLAddAdvViewController.h
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import "LLBaseViewController.h"
#import "LLAdvObject.h"

typedef NS_ENUM(NSInteger, EditAdvType) {
    EditAdvType_New  = 0,
    EditAdvType_Edit = 1,
};

@interface LLEditAdvViewController : LLBaseViewController

@property (nonatomic, strong) LLAdvObject *adv;
@property (nonatomic, assign) EditAdvType type;
@property (nonatomic, copy  ) void        (^completeBlock)(LLAdvObject *adv);

@end
