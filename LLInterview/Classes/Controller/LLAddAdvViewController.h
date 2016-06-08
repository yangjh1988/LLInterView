//
//  LLAddAdvViewController.h
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import "LLBaseViewController.h"
#import "LLAdvObject.h"

@interface LLAddAdvViewController : LLBaseViewController

@property (nonatomic, copy) void (^completeBlock)(LLAdvObject *adv);

@end
