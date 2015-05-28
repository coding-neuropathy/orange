//
//  JXFormCell.h
//  meimeitaoios
//
//  Created by 谢家欣 on 14/10/26.
//  Copyright (c) 2014年 谢家欣. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JXUserSignStyle) {
    JXUserSignStyleNickname,
    JXUserSignStyleEmail,
    JXUserSignStylePassword,
    JXUserSignStyleConfirmPassword,
    JXUserSignStyleButton,
    JXUserSignStyleGender,
    JXUserSignStyleBio,
    JXUserSignStyleLocation,

//    JXUserSignStyleWeiBoOrWeChat,
//    JXUserSignStyleMobile,
//    JXUserSignStyleCode,
};

@interface JXFormCell : UITableViewCell

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel * fieldLabel;
//@property (strong, nonatomic) UIButton * button;

@end
