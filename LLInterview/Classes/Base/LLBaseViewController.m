//
//  BaseViewController.m
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import "LLBaseViewController.h"
#import <MBProgressHUD.h>

@interface LLBaseViewController ()

@end

@implementation LLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIColor darkTextColor],NSForegroundColorAttributeName,
                             [UIFont systemFontOfSize:18.0],NSFontAttributeName, nil]
     forState:UIControlStateNormal];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight
    |UIViewAutoresizingFlexibleWidth
    |UIViewAutoresizingFlexibleBottomMargin
    |UIViewAutoresizingFlexibleTopMargin;
    
    CGRect rect = self.view.frame;
    if (self.hidesBottomBarWhenPushed == NO) {
        rect.size.height -= 44.0;
    }
    self.view.frame = rect;
    
//    [self setNavigationLeftItemWithTitle:@"返回" action:@selector(backAction)];
    // Do any additional setup after loading the view.
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationTitleWith:(NSString *)title
{
    self.navigationItem.title = title;
    NSDictionary *attDic = [NSDictionary dictionaryWithObjectsAndKeys:
                            [UIColor darkTextColor],NSForegroundColorAttributeName,
                            [UIFont systemFontOfSize:18.0],NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attDic;
}

- (void)setNavigationLeftItemWithTitle:(NSString *)title action:(SEL)action
{
    if (title&&![title isEqualToString:@""]) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:action];
        leftItem.tintColor = [UIColor darkTextColor];
        [self.navigationItem setLeftBarButtonItem:leftItem];
    }
    else {
        [self.navigationItem setLeftBarButtonItem:nil];
    }
}

- (void)setNavigationLeftItemWithSystemItem:(UIBarButtonSystemItem)item Action:(SEL)action
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:action];
    leftItem.tintColor = [UIColor darkTextColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}

- (void)setNavigationRightItemWithSystemItem:(UIBarButtonSystemItem)item Action:(SEL)action
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:action];
    rightItem.tintColor = [UIColor darkTextColor];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)setNavigationRightItemWithTitle:(NSString *)title action:(SEL)action
{
    if (title&&![title isEqualToString:@""]) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:action];
        rightItem.tintColor = [UIColor darkTextColor];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
    else {
        [self.navigationItem setRightBarButtonItem:nil];
    }
}

#pragma mark -- private methods --
- (void)showProcessHUD
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)hideProcessHUD
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)showToast:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.5];
}

@end
