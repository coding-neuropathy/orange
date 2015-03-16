//
//  UIPlaceHolderTextView.h
//  basechem
//
//  Created by 谢 家欣 on 12-4-4.
//  Copyright (c) 2012年 QIN Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
{
    NSString * _placeholder;
    UIColor * _placeholdeColor;

//@private
//    UILabel * _placeholdeLabel;
}

@property (nonatomic, strong) NSString * placeholder;
@property (nonatomic, strong) UIColor * placeholderColor;
//@property (nonatomic, strong) UIColor * back

@end
