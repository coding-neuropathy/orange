//
//  MessageCell.h
//  orange
//
//  Created by 谢家欣 on 16/9/22.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (weak, nonatomic) GKArticle   *article;
@property (strong, nonatomic) UIImage   *coverImage;

@end
