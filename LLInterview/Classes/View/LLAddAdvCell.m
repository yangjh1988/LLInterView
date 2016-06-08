//
//  LLAddAdvCell.m
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import "LLAddAdvCell.h"

#define kAddAdvCellHeight  44.0

#define kLabelWidth        60.0
#define kLabelHeight       20.0
#define kLabelLeftEdge     15.0
#define kLabelTopEdge      ((kAddAdvCellHeight-kLabelHeight)/2.0)

#define kTextFieldWidth    (kScreenWidth-kTextFieldLeftEdge-kLabelLeftEdge)
#define kTextFieldHeight   30.0
#define kTextFieldLeftEdge (kLabelLeftEdge+kLabelWidth)
#define kTextFieldTopEdge  ((kAddAdvCellHeight-kTextFieldHeight)/2.0)

#define kLabelFont     16.0
#define kTextFieldFont 16.0

@interface LLAddAdvCell ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel     *label;

@end

@implementation LLAddAdvCell
- (id)initWithTitle:(NSString *)title textField:(UITextField *)textField
{
    self = [super init];
    if (self) {
        self.textField = textField;
        [self setupViewsWithTitle:title];
    }
    return self;
}

- (void)setupViewsWithTitle:(NSString *)title
{
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(kLabelLeftEdge,
                                                           kLabelTopEdge,
                                                           kLabelWidth,
                                                           kLabelHeight)];
    self.label.text = title;
    self.label.font = [UIFont systemFontOfSize:kLabelFont];
    [self addSubview:self.label];
    
    self.textField.frame = CGRectMake(kTextFieldLeftEdge,
                                      kTextFieldTopEdge,
                                      kTextFieldWidth,
                                      kTextFieldHeight);
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.font = [UIFont systemFontOfSize:kTextFieldFont];
    [self addSubview:self.textField];
}

@end
