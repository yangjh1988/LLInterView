//
//  BaseViewController.h
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLObjects.h"
#import "LLNetworkObjects.h"
#import "LLNetworkManager.h"
#import "LLActionSheetView.h"
#import "LLDBManager.h"

@interface LLBaseViewController : UIViewController

- (void)setNavigationTitleWith:(NSString *)title;
- (void)setNavigationLeftItemWithTitle:(NSString *)title action:(SEL)action;
- (void)setNavigationRightItemWithTitle:(NSString *)title action:(SEL)action;
- (void)setNavigationLeftItemWithSystemItem:(UIBarButtonSystemItem)item Action:(SEL)action;
- (void)setNavigationRightItemWithSystemItem:(UIBarButtonSystemItem)item Action:(SEL)action;

- (void)showProcessHUD;
- (void)hideProcessHUD;
- (void)showToast:(NSString *)text;

@end
