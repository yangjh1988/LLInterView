//
//  LLBaseCell.h
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLObjects.h"


#define kScreenWidth        [[UIScreen mainScreen] bounds].size.width

typedef void(^CellAction)(NSInteger index, id obj);
typedef void(^CellActionIndexPath) (NSIndexPath *indexPath, id obj);

@interface LLBaseCell : UITableViewCell

@property (nonatomic, copy  ) CellAction          action;
@property (nonatomic, copy  ) CellActionIndexPath indexPathAction;
@property (nonatomic, assign) NSInteger           index;
@property (nonatomic, strong) NSIndexPath         *indexPath;

- (void)setupCellWithItem:(LLBaseObject *)item
                indexPath:(NSIndexPath *)indexPath
              actionBlock:(CellActionIndexPath)action;

- (void)setupCellWithItem:(LLBaseObject *)item
                    index:(NSInteger)index
              actionBlock:(CellAction)action;

- (void)setupCellWithItems:(NSArray *)dataArray
                     index:(NSInteger)index
               actionBlock:(CellAction)action;

+ (CGFloat)heightForCell;
+ (CGFloat)heightForCellWithObject:(LLBaseObject *)obj;

@end
