//
//  SubCategoryEntityController.h
//  orange
//
//  Created by 谢家欣 on 15/9/16.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "BaseViewController.h"
#import "DataStructure.h"

@interface SubCategoryEntityController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (instancetype)initWithSubCategory:(GKEntityCategory *)subcategory;

@end