//
//  EntityThreeGridCell.m
//  Blueberry
//
//  Created by 魏哲 on 13-9-26.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "EntityThreeGridCell.h"



@interface EntityThreeGridCell()

@property (nonatomic, strong) NSMutableArray *itemArray;

@end

@implementation EntityThreeGridCell

+ (CGFloat)height
{
    return kScreenWidth/3;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    }
    return self;
}

- (void)setEntityArray:(NSArray *)entityArray
{
    _entityArray = entityArray;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.itemArray) {
        _itemArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 3; i++) {
                UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(5+i*(kScreenWidth/3), 5, kScreenWidth/3-10, kScreenWidth/3-10)];
                [self.itemArray addObject:button];
                [self addSubview:button];
            }
    }

    for (NSUInteger i = 0; i < 3; i++) {
        UIButton *item = self.itemArray[i];
        if (i < self.entityArray.count) {
            GKEntity * entity = self.entityArray[i];
            [item sd_setImageWithURL:entity.imageURL_240x240 forState:UIControlStateNormal];
            item.hidden = NO;
        } else {
            item.hidden = YES;
        }
    }
}

@end
