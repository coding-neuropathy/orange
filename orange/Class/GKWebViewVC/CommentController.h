//
//  CommentController.h
//  orange
//
//  Created by D_Collin on 16/7/21.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentController : UIViewController

@property (nonatomic , strong)GKArticleComment * comment;

@property (nonatomic, strong)GKArticle * article;

@property (nonatomic , copy) void (^commentSuccessBlock)(GKArticleComment *);

@end
