//
//  ArticleCell.h
//  orange
//
//  Created by 谢家欣 on 15/9/5.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleCell : UICollectionViewCell

@property (strong, nonatomic) GKArticle * article;

+ (CGSize)CellSizeWithArticle:(GKArticle *)article;

@end
