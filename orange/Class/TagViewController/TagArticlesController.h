//
//  TagArticlesController.h
//  orange
//
//  Created by 谢家欣 on 15/9/30.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "BaseViewController.h"

@interface TagArticlesController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (instancetype)initWithTagName:(NSString *)name;

@end
