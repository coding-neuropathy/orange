//
//  SubCategoryGroupController.h
//  orange
//
//  Created by 谢家欣 on 15/9/16.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "BaseViewController.h"

@interface SubCategoryGroupController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (instancetype)initWithSubCategories:(NSArray *)subcategories;

@end
