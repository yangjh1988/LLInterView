//
//  LLAlertManager.h
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LLActionSheetView : NSObject

+ (LLActionSheetView *)shareInstance;

- (void)showAlertViewWith:(NSString *)title
                  message:(NSString *)message
                      tag:(NSInteger)tag
              buttonBlock:(void(^)(NSInteger buttongIndex, UIAlertView *alert))buttonBlock
        cancelButtonTitle:(NSString *)cancelTitle
         otherButtonTitle:(NSArray *)otherTitles;

- (void)showActionSheetWith:(NSString *)title
                        tag:(NSInteger)tag
                 showInView:(UIView *)view
                buttonBlock:(void (^)(NSInteger buttonIndex, UIActionSheet *actionSheet))buttonBlock
          cancelButtonTitle:(NSString *)cancelButtonTitle
      destuctiveButtonTitle:(NSString *)destuctiveButtonTitle
           otherButtonTitle:(NSArray *)otherButtonTitles;

- (void)showAlertViewWith:(NSString *)title message:(NSString *)message;

@end
