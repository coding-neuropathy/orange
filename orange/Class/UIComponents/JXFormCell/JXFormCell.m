//
//  JXFormCell.m
//  meimeitaoios
//
//  Created by 谢家欣 on 14/10/26.
//  Copyright (c) 2014年 谢家欣. All rights reserved.
//

#import "JXFormCell.h"

@implementation JXFormCell

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 0.;
    frame.size.width = kScreenWidth;
    [super setFrame:frame];
}

#pragma mark - init view

- (UILabel *)fieldLabel
{
    if (!_fieldLabel) {
        _fieldLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _fieldLabel.textColor = UIColorFromRGB(0x9d9e9f);
        _fieldLabel.font = [UIFont systemFontOfSize:17.];
        _fieldLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _fieldLabel;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.adjustsFontSizeToFitWidth = YES;
        
//        UIView * paddingView = [[UIView alloc] initWithFrame:CGRectMake(0., 0., 50., self.frame.size.height)];
        self.fieldLabel.frame = CGRectMake(0., 0., 100., self.frame.size.height);
        _textField.leftView = self.fieldLabel;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        //        _textField.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_textField];
    }
    return _textField;
}

//- ()

@end
