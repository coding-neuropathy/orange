//
//  NoMessageView.m
//  orange
//
//  Created by 谢家欣 on 15/3/17.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "NoMessageView.h"

//@interface NoMessageView ()


//@property (strong, nonatomic) UILabel * titleLabel;
//@property (strong, nonatomic) UILabel * detailLabel;
//@property (strong, nonatomic) UIImageView * noticImageView;

//@end

@implementation NoMessageView




//- (UILabel *)titleLabel
//{
//    if (!_titleLabel) {
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _titleLabel.backgroundColor = [UIColor clearColor];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.font = [UIFont systemFontOfSize:16.];
//        _titleLabel.textColor = UIColorFromRGB(0x414243);
//        [self addSubview:_titleLabel];
//    }
//    return _titleLabel;
//}




- (void)setType:(EmptyType)type
{
    _type = type;
    
    switch (_type) {
        case NoMessageType:
        {
            self.titleLabel.text = @"没有任何消息";
            self.detailLabel.text = @"当有人关注你、点评你添加的商品\n或发生任何与你相关的事件时，会在这里通知你";
            
            UIImage * noticImage = [UIImage imageNamed:@"empty_notifaction.png"];
            self.noticImageView.image = noticImage;
        }
            break;
        case NoFeedType:
        {
            self.titleLabel.text = @"没有任何动态";
            self.detailLabel.text = @"关注活跃用户，\nTA 们的动态将出现在这里";
            
            UIImage * noticImage = [UIImage imageNamed:@"empty_act.png"];
            self.noticImageView.image = noticImage;
        }
            break;
        default:
            break;
    }
    
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.noticImageView.frame = CGRectMake((kScreenWidth - self.noticImageView.image.size.width) / 2, 0., self.noticImageView.image.size.width, self.noticImageView.image.size.width);
    self.noticImageView.deFrameTop = 60.;
    
    self.titleLabel.frame = CGRectMake(0., 0., kScreenWidth, 20.);
    self.titleLabel.font = [UIFont systemFontOfSize:16.];
    self.titleLabel.textColor = UIColorFromRGB(0x414243);;
    self.titleLabel.deFrameTop = self.noticImageView.frame.origin.y + self.noticImageView.frame.size.height + 40.;
    
    self.detailLabel.frame = CGRectMake(0., 40., kScreenWidth, 40.);
    self.detailLabel.deFrameTop = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10.;
}

@end
