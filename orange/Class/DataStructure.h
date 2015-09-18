//
//  DataStructure.h
//  orange
//
//  Created by 谢家欣 on 15/9/17.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

//#ifndef DataStructure_h
//#define DataStructure_h
//
//
//#endif /* DataStructure_h */


/**
 *  商品显示样式
 */
typedef NS_ENUM(NSInteger, EntityDisplayStyle) {
    ListStyle = 0,
    GridStyle,
};

/**
 *  搜索类型
 *
 */
typedef NS_ENUM(NSInteger, SearchType) {
    EntityType,
    ArticleType,
    CategoryType,
    UserType,
};