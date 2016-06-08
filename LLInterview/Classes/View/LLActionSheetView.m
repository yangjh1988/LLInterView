
//
//  FWAlertManager.m
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import "LLActionSheetView.h"
#import <objc/runtime.h>

#define NSArrayObjectMaybeNil(__ARRAY__, __INDEX__) ((__INDEX__ >= [__ARRAY__ count]) ? nil : [__ARRAY__ objectAtIndex:__INDEX__])
#define NSArrayToVariableArgumentsList(__ARRAYNAME__) NSArrayObjectMaybeNil(__ARRAYNAME__, 0), NSArrayObjectMaybeNil(__ARRAYNAME__, 1), NSArrayObjectMaybeNil(__ARRAYNAME__, 2), NSArrayObjectMaybeNil(__ARRAYNAME__, 3), NSArrayObjectMaybeNil(__ARRAYNAME__, 4), NSArrayObjectMaybeNil(__ARRAYNAME__, 5), NSArrayObjectMaybeNil(__ARRAYNAME__, 6), NSArrayObjectMaybeNil(__ARRAYNAME__, 7), NSArrayObjectMaybeNil(__ARRAYNAME__, 8), NSArrayObjectMaybeNil(__ARRAYNAME__, 9), nil

static LLActionSheetView *alert = nil;

@interface LLActionSheetView ()
<UIAlertViewDelegate,
UIActionSheetDelegate>

@property (nonatomic, copy) void (^alertButtonBlock)(NSInteger buttonIndex, UIAlertView *alert);
@property (nonatomic, assign) NSInteger blockAlertTag;

@property (nonatomic, copy) void (^sheetButtonblock)(NSInteger buttonIndex, UIActionSheet *sheet);
@property (nonatomic, assign) NSInteger blockSheetTag;

@end

@implementation LLActionSheetView

+ (LLActionSheetView *)shareInstance
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        alert = [[self alloc] init];
    });
    return alert;
}

- (void)showAlertViewWith:(NSString *)title
                  message:(NSString *)message
                      tag:(NSInteger)tag
              buttonBlock:(void(^)(NSInteger buttongIndex, UIAlertView *alert))buttonBlock
        cancelButtonTitle:(NSString *)cancelTitle
         otherButtonTitle:(NSArray *)otherTitles
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:NSArrayToVariableArgumentsList(otherTitles)];
    self.alertButtonBlock = buttonBlock;
    self.blockAlertTag = tag;
    alert.tag = self.blockAlertTag;
    [alert show];
}

- (void)showActionSheetWith:(NSString *)title
                        tag:(NSInteger)tag
                 showInView:(UIView *)view
                buttonBlock:(void (^)(NSInteger buttonIndex, UIActionSheet *actionSheet))buttonBlock
          cancelButtonTitle:(NSString *)cancelButtonTitle
      destuctiveButtonTitle:(NSString *)destuctiveButtonTitle
           otherButtonTitle:(NSArray *)otherButtonTitles
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title
                                                       delegate:self
                                              cancelButtonTitle:cancelButtonTitle
                                         destructiveButtonTitle:destuctiveButtonTitle
                                              otherButtonTitles:NSArrayToVariableArgumentsList(otherButtonTitles)];

    self.sheetButtonblock = buttonBlock;
    sheet.tag = tag;
    self.blockSheetTag = tag;
    
    if (view) {
        [sheet showInView:view];
    }
    else {
        [sheet showInView:[[UIApplication sharedApplication] keyWindow]];
    }
}

- (void)showAlertViewWith:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    [alert show];
}

#pragma mark -- UIAlertView Delegate --
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.blockAlertTag!=0) {
        if (alertView.tag==self.blockAlertTag) {
            if (self.alertButtonBlock) {
                self.alertButtonBlock(buttonIndex,alertView);
            }
            self.blockAlertTag=0;
        }
    }
    else {
        if (self.alertButtonBlock) {
            self.alertButtonBlock(buttonIndex,alertView);
        }
    }
}

#pragma mark -- UIActionSheetView Delegate --
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.blockSheetTag!=0) {
        if (actionSheet.tag==self.blockSheetTag) {
            if (self.sheetButtonblock) {
                self.sheetButtonblock(buttonIndex,actionSheet);
            }
            self.blockSheetTag=0;
        }
    }
    else {
        if (self.sheetButtonblock) {
            self.sheetButtonblock(buttonIndex,actionSheet);
        }
        self.blockSheetTag=0;
    }
}

@end
