//
//  Constant.h
//  TaeSDKSample
//
//  Created by 千醒 on 15/1/21.
//  Copyright (c) 2015年 com.taobao. All rights reserved.
//


/*!
 @brief ItemType可选值
 !*/
typedef NS_ENUM(NSInteger, OneSDKItemType)
{
    OneSDKItemType_TAOBAO1      = 0,
    OneSDKItemType_TAOBAO2      = 1,
    OneSDKItemType_TMALL1       = 2,
    OneSDKItemType_TMALL2       = 3,
    OneSDKItemType_NotExist     = 4,     //针对不需要宝贝类型选择的case（如：淘客Pid，FreeOpenIM等）
    
    OneSDKItemType_SNSHOP       = 10,
    OneSDKItemType_IDAUCTION    = 11,
};


/*!
 @brief CaseType可选值
 !*/
typedef NS_ENUM(NSInteger, OneSDKCaseType)
{
    OneSDKCaseType_Item         = 0,
    OneSDKCaseType_TaoKe        = 1,
    OneSDKCaseType_Cart         = 2,
    OneSDKCaseType_FreeOpenIM   = 3,
    OneSDKCaseType_Promotion    = 4,
    OneSDKCaseType_ETicket      = 5,
};