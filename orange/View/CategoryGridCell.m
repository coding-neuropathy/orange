//
//  CategoryGridCell.m
//  Blueberry
//
//  Created by 魏哲 on 13-9-24.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "CategoryGridCell.h"

@interface CategoryGridCell()

@property (nonatomic, strong) NSArray *itemArray;

@end

@implementation CategoryGridCell

+ (CGFloat)height
{
    return IS_IPHONE ? kScreenWidth/4-2 : (kScreenWidth - kTabBarWidth)/4-2;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}
- (void)setType:(NSInteger)type
{
    _type = type;
    [self setNeedsLayout];
}
- (void)setCategoryArray:(NSArray *)categoryArray
{
    _categoryArray = categoryArray;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (!self.itemArray) {
        CategoryGridItem *item0 = [[CategoryGridItem alloc] init];
        [item0 setDeFrameOrigin:CGPointMake(7, 4)];
        [self.contentView addSubview:item0];

        CategoryGridItem *item1 = [[CategoryGridItem alloc] init];
        IS_IPHONE ? [item1 setDeFrameOrigin:CGPointMake(7+kScreenWidth/4-2, 4)] : [item1 setDeFrameOrigin:CGPointMake(7+(kScreenWidth - kTabBarWidth)/4-2, 4)];
        [self.contentView addSubview:item1];
        
        CategoryGridItem *item2 = [[CategoryGridItem alloc] init];

        IS_IPHONE ? [item2 setDeFrameOrigin:CGPointMake(7+(kScreenWidth/4-2)*2, 4)] : [item2 setDeFrameOrigin:CGPointMake(7+((kScreenWidth - kTabBarWidth)/4-2)*2, 4)];
        [self.contentView addSubview:item2];
        
        CategoryGridItem *item3 = [[CategoryGridItem alloc] init];
        IS_IPHONE ? [item3 setDeFrameOrigin:CGPointMake(7+(kScreenWidth/4-2)*3, 4)] : [item3 setDeFrameOrigin:CGPointMake(7+((kScreenWidth - kTabBarWidth)/4-2)*3, 4)];
        [self.contentView addSubview:item3];
        self.itemArray = @[item0, item1, item2 ,item3];
        
        switch (self.type) {
            case CategoryCridCellTypeForFourWithIcon:
            {
                [item0 setType:CategoryCridItemTypeForFourWithIcon];
                [item1 setType:CategoryCridItemTypeForFourWithIcon];
                [item2 setType:CategoryCridItemTypeForFourWithIcon];
                [item3 setType:CategoryCridItemTypeForFourWithIcon];
                break;
            }
            case CategoryCridCellTypeForFourWithOutIcon:
            {
                [item0 setType:CategoryCridItemTypeForFourWithOutIcon];
                [item1 setType:CategoryCridItemTypeForFourWithOutIcon];
                [item2 setType:CategoryCridItemTypeForFourWithOutIcon];
                [item3 setType:CategoryCridItemTypeForFourWithOutIcon];
                break;
            }
            default:
            {
                [item0 setType:CategoryCridItemTypeForFourWithIcon];
                [item1 setType:CategoryCridItemTypeForFourWithIcon];
                [item2 setType:CategoryCridItemTypeForFourWithIcon];
                [item3 setType:CategoryCridItemTypeForFourWithIcon];
                break;
            }
        }
    }
    
    for (NSUInteger i = 0; i < 4; i++) {
        CategoryGridItem *item = self.itemArray[i];
        if (i < self.categoryArray.count) {
            item.category = self.categoryArray[i];
        } else {
            item.category = nil;
        }
    }
}

@end
