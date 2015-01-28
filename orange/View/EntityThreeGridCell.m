//
//  EntityThreeGridCell.m
//  Blueberry
//
//  Created by 魏哲 on 13-9-26.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "EntityThreeGridCell.h"
#import "EntityViewController.h"



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
        self.contentView.backgroundColor = UIColorFromRGB(0xffffff);
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
                UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(18+i*((kScreenWidth-20)/3), 10, (kScreenWidth-20)/3-16, (kScreenWidth-20)/3-16)];
                [self.itemArray addObject:button];
                button.layer.borderColor = UIColorFromRGB(0xeeeeee).CGColor;
                button.layer.borderWidth = 0.5;
            
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i;
                [self addSubview:button];
            }
    }

    for (NSUInteger i = 0; i < 3; i++) {
        UIButton *item = self.itemArray[i];
        if (i < self.entityArray.count) {
            GKEntity * entity = self.entityArray[i];
            [item sd_setImageWithURL:entity.imageURL_240x240 forState:UIControlStateNormal placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xffffff) andSize:CGSizeMake(kScreenWidth/3-16, kScreenWidth/3-16)]];
            item.hidden = NO;
        } else {
            item.hidden = YES;
        }
    }
}

- (void)buttonAction:(UIButton *)button
{
    
    EntityViewController * VC = [[EntityViewController alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    VC.entity = [self.entityArray objectAtIndex:button.tag];
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
}

@end
