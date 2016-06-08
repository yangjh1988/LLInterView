//
//  LLBaseCell.m
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import "LLBaseCell.h"

@implementation LLBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.userInteractionEnabled = NO;
        [self.contentView removeFromSuperview];
        [self resizeFrame];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.userInteractionEnabled = NO;
    [self resizeFrame];
}

- (void)resizeFrame
{
    CGRect rect = self.frame;
    rect.size.width = kScreenWidth;
    self.frame = rect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setupCellWithItem:(LLBaseObject *)item
                indexPath:(NSIndexPath *)indexPath
              actionBlock:(CellActionIndexPath)action
{
    if (action) {
        self.indexPathAction = action;
    }
    self.indexPath = indexPath;
}

- (void)setupCellWithItem:(LLBaseObject *)item
                    index:(NSInteger)index
              actionBlock:(CellAction)action
{
    if (action) {
        self.action = action;
    }
    self.index = index;
}

- (void)setupCellWithItems:(NSArray *)dataArray
                     index:(NSInteger)index
               actionBlock:(CellAction)action
{
    if (action) {
        self.action = action;
    }
    self.index = index;
}

+ (CGFloat)heightForCell
{
    return 44;
}

+ (CGFloat)heightForCellWithObject:(LLBaseObject *)obj
{
    return 44;
}

@end
