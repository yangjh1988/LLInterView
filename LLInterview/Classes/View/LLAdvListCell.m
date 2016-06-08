//
//  LLAdvListCell.m
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import "LLAdvListCell.h"

#define kTitleLabelLeftEdge     15.0
#define kTitleLabelTopEdge      5.0
#define kTitleLabelWidth        (kScreenWidth-2*kTitleLabelLeftEdge-30.0)
#define kTitleLabelHeight       20.0

#define kUrlLabelleftEdge       kTitleLabelLeftEdge
#define kUrlLabelTopEdge        (kTitleLabelTopEdge+kTitleLabelHeight)
#define kUrlLabelWidth          kTitleLabelWidth
#define kUrlLabelHeight         kTitleLabelHeight

#define kCreatedAtLabelLeftEdge kUrlLabelleftEdge
#define kCreatedAtLabelTopEdge  (kUrlLabelTopEdge+kUrlLabelHeight)
#define kCreatedAtLabelWidth    kUrlLabelWidth
#define kCreatedAtLabelHeight   kUrlLabelHeight

#define kUpdatedAtLabelLeftEdge kCreatedAtLabelLeftEdge
#define kUpdatedAtLabelTopEdge  (kCreatedAtLabelTopEdge+kCreatedAtLabelHeight)
#define kUpdatedAtLabelWidth    kCreatedAtLabelWidth
#define kUpdatedAtLabelHeight   kCreatedAtLabelHeight

#define kLabelFont              16.0

#define kAdvListCellHeight      (kTitleLabelHeight+kUrlLabelHeight+kCreatedAtLabelHeight+kUpdatedAtLabelHeight+2*kTitleLabelTopEdge)

@interface LLAdvListCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *urlLabel;
@property (nonatomic, strong) UILabel *createdAtLabel;
@property (nonatomic, strong) UILabel *updatedAtLabel;

@end

@implementation LLAdvListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    if (!self.titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTitleLabelLeftEdge,
                                                                    kTitleLabelTopEdge,
                                                                    kTitleLabelWidth,
                                                                    kTitleLabelHeight)];
        self.titleLabel.font = [UIFont systemFontOfSize:kLabelFont];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.titleLabel];
    }
    if (!self.urlLabel) {
        self.urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUrlLabelleftEdge,
                                                                  kUrlLabelTopEdge,
                                                                  kUrlLabelWidth,
                                                                  kUrlLabelHeight)];
        self.urlLabel.font = [UIFont systemFontOfSize:kLabelFont];
        self.urlLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.urlLabel];
    }
    if (!self.createdAtLabel) {
        self.createdAtLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCreatedAtLabelLeftEdge,
                                                                        kCreatedAtLabelTopEdge,
                                                                        kCreatedAtLabelWidth,
                                                                        kCreatedAtLabelHeight)];
        self.createdAtLabel.font = [UIFont systemFontOfSize:kLabelFont];
        self.createdAtLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.createdAtLabel];
    }
    if (!self.updatedAtLabel) {
        self.updatedAtLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUpdatedAtLabelLeftEdge,
                                                                        kUpdatedAtLabelTopEdge,
                                                                        kUpdatedAtLabelWidth,
                                                                        kUpdatedAtLabelHeight)];
        self.updatedAtLabel.font = [UIFont systemFontOfSize:kLabelFont];
        self.updatedAtLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.updatedAtLabel];
    }
}

- (void)setupCellWithItem:(LLBaseObject *)item index:(NSInteger)index actionBlock:(CellAction)action
{
    [super setupCellWithItem:item index:index actionBlock:action];
    if ([item isKindOfClass:[LLAdvObject class]]) {
        LLAdvObject *adv = (LLAdvObject *)item;
        self.titleLabel.text = adv.title;
        self.urlLabel.text = adv.url;
        self.createdAtLabel.text = adv.created_at;
        self.updatedAtLabel.text = adv.updated_at;
    }
}

+ (CGFloat)heightForCell
{
    return kAdvListCellHeight;
}

@end
