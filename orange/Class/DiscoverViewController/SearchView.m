//
//  SearchView.m
//  orange
//
//  Created by D_Collin on 16/7/7.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "SearchView.h"

@interface SearchView ()

//左线
@property (nonatomic ,strong)UIView * line1;
//右线
@property (nonatomic ,strong)UIView * line2;
//搜你想要的
@property (nonatomic ,strong)UILabel * label;

@property (nonatomic , strong)UIImageView * img1;
@property (nonatomic , strong)UILabel * label1;
@property (nonatomic , strong)UIImageView * img2;
@property (nonatomic , strong)UILabel * label2;
@property (nonatomic , strong)UIImageView * img3;
@property (nonatomic , strong)UILabel * label3;
@property (nonatomic , strong)UIImageView * img4;
@property (nonatomic , strong)UILabel * label4;
@end

@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setHotArray:(NSArray *)hotArray withRecentArray:(NSArray *)recentArray
{
     _hotArray = hotArray;
    _recentArray = recentArray;
    
//    [self setData];
    
    [self setNeedsLayout];
    
    
}


- (UIView *)line1
{
    if (!_line1) {
        _line1 = [[UIView alloc]initWithFrame:CGRectMake(50., 178., (kScreenWidth - 100)/3, 1.)];
        _line1.backgroundColor = UIColorFromRGB(0xbdbdbd);
        
    }
    return _line1;
}


- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(50. + (kScreenWidth - 100)/3, 163., (kScreenWidth - 100)/3, 30.)];
        _label.text = [NSString stringWithFormat:@"搜你想要的"];
        _label.font = [UIFont systemFontOfSize:14.];
        _label.textColor = UIColorFromRGB(0xbdbdbd);
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
    }
    return _label;
}

- (UIView *)line2
{
    if (!_line2) {
        _line2 = [[UIView alloc]initWithFrame:CGRectMake(50. + (kScreenWidth - 100)/3 * 2, 178., (kScreenWidth - 100)/3, 1.)];
        _line2.backgroundColor = UIColorFromRGB(0xbdbdbd);
        
    }
    return _line2;
}

- (UIImageView *)img1
{
    if (!_img1) {
        _img1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blue"]];
        _img1.frame = CGRectZero;
        _img1.alpha = 0.6;
        [self addSubview:self.img1];
    }
    return _img1;
}

- (UIImageView *)img2
{
    if (!_img2) {
        _img2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yellow"]];
        _img2.frame = CGRectZero;
        _img2.alpha = 0.6;
        [self addSubview:self.img2];
    }
    return _img2;
}

- (UIImageView *)img3
{
    if (!_img3) {
        _img3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"red"]];
        _img3.frame = CGRectZero;
        _img3.alpha = 0.6;
        [self addSubview:self.img3];
    }
    return _img3;
}

- (UIImageView *)img4
{
    if (!_img4) {
        _img4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"green"]];
        _img4.frame = CGRectZero;
        _img4.alpha = 0.6;
        [self addSubview:self.img4];
    }
    return _img4;
}

- (UILabel *)label1
{
    if (!_label1) {
        _label1 = [[UILabel alloc]initWithFrame:CGRectZero];
        _label1.text = [NSString stringWithFormat:@"商品"];
        _label1.textColor = UIColorFromRGB(0x414243);
        _label1.textAlignment = NSTextAlignmentCenter;
        _label1.font = [UIFont systemFontOfSize:14.];
        _label1.alpha = 0.6;
        [self addSubview:self.label1];
    }
    return _label1;
}

- (UILabel *)label2
{
    if (!_label2) {
        _label2 = [[UILabel alloc]initWithFrame:CGRectZero];
        _label2.text = [NSString stringWithFormat:@"品类"];
        _label2.textColor = UIColorFromRGB(0x414243);
        _label2.textAlignment = NSTextAlignmentCenter;
        _label2.font = [UIFont systemFontOfSize:14.];
        _label2.alpha = 0.6;
        [self addSubview:self.label2];
    }
    return _label2;
}

- (UILabel *)label3
{
    if (!_label3) {
        _label3 = [[UILabel alloc]initWithFrame:CGRectZero];
        _label3.text = [NSString stringWithFormat:@"图文"];
        _label3.textColor = UIColorFromRGB(0x414243);
        _label3.textAlignment = NSTextAlignmentCenter;
        _label3.font = [UIFont systemFontOfSize:14.];
        _label3.alpha = 0.6;
        [self addSubview:self.label3];
    }
    return _label3;
}

- (UILabel *)label4
{
    if (!_label4) {
        _label4 = [[UILabel alloc]initWithFrame:CGRectZero];
        _label4.text = [NSString stringWithFormat:@"用户"];
        _label4.textColor = UIColorFromRGB(0x414243);
        _label4.textAlignment = NSTextAlignmentCenter;
        _label4.font = [UIFont systemFontOfSize:14.];
        _label4.alpha = 0.6;
        [self addSubview:self.label4];
    }
    return _label4;
}

- (void)setData
{
    if (self.hotArray.count != 0) {
        for (NSInteger i = 0; i < 5; i++) {
            UIButton * categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            GKEntityCategory * entitycategory = [self.hotArray objectAtIndex:i];
            [categoryBtn setTitle:entitycategory.categoryName forState:UIControlStateNormal];
            [categoryBtn setTitle:[self.hotArray objectAtIndex:i] forState:UIControlStateNormal];
            [categoryBtn setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
            categoryBtn.layer.cornerRadius = 12.;
            categoryBtn.backgroundColor = UIColorFromRGB(0xf8f8f8);
            categoryBtn.layer.masksToBounds = YES;
            categoryBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
            categoryBtn.tag = i;
            if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
                categoryBtn.titleLabel.font = [UIFont systemFontOfSize:12.];
                categoryBtn.frame = CGRectMake(10. + (55 + 5) * i, 66., 50., 25);
                categoryBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
            } else
            {
                categoryBtn.frame = CGRectMake(20. + (50 + 5) * i, 66., 50., 25);
            }
            [categoryBtn addTarget:self action:@selector(hotCategoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:categoryBtn];
        }
    }
    
    if (self.recentArray.count != 0) {
        for (NSInteger i = 0; i < self.recentArray.count; i ++) {
            UIButton * recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [recordBtn setTitle:[self.recentArray objectAtIndex:i] forState:UIControlStateNormal];
            [recordBtn setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
            recordBtn.layer.cornerRadius = 12.;
            recordBtn.backgroundColor = UIColorFromRGB(0xf8f8f8);
            recordBtn.layer.masksToBounds = YES;
            recordBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
            recordBtn.tag = i + 324;
            if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
                recordBtn.titleLabel.font = [UIFont systemFontOfSize:12.];
                recordBtn.frame = CGRectMake(10. + (55 + 5) * i, 16., 50., 25);
                recordBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
            } else
            {
                recordBtn.frame = CGRectMake(20. + (50 + 5) * i, 16., 50., 25);
            }
            [recordBtn addTarget:self action:@selector(recordBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:recordBtn];
        }
    }
    

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setData];
    [self addSubview:self.line1];
    [self addSubview:self.line2];
    
    self.img1.frame = CGRectMake(0., 0., 10., 10.);
    self.img2.frame = CGRectMake(0., 0., 10., 10.);
    self.img3.frame = CGRectMake(0., 0., 10., 10.);
    self.img4.frame = CGRectMake(0., 0., 10., 10.);
    
    self.label1.frame = CGRectMake(0., 0., 30., 25.);
    self.label2.frame = CGRectMake(0., 0., 30., 25.);
    self.label3.frame = CGRectMake(0., 0., 30., 25.);
    self.label4.frame = CGRectMake(0., 0., 30., 25.);
#pragma mark -----------------
    self.img1.deFrameTop = self.label.deFrameBottom + 50.;
    self.img1.deFrameLeft = self.deFrameLeft + 40;
    self.label1.deFrameLeft = self.img1.deFrameRight + 6.;
    self.label1.deFrameTop = self.img1.deFrameTop - 6;
    
    self.img2.deFrameTop = self.label.deFrameBottom + 50.;
    self.img2.deFrameLeft = self.label1.deFrameRight + 35.;
    self.label2.deFrameLeft = self.img2.deFrameRight + 6;
    self.label2.deFrameTop = self.img2.deFrameTop - 6;
    
    self.img3.deFrameTop = self.label.deFrameBottom + 50.;
    self.img3.deFrameLeft = self.label2.deFrameRight + 35.;
    self.label3.deFrameLeft = self.img3.deFrameRight + 6;
    self.label3.deFrameTop = self.img3.deFrameTop - 6;
    
    self.img4.deFrameTop = self.label.deFrameBottom + 50.;
    self.img4.deFrameLeft = self.label3.deFrameRight + 35;
    self.label4.deFrameLeft = self.img4.deFrameRight + 6;
    self.label4.deFrameTop = self.img4.deFrameTop - 6;
    
<<<<<<< HEAD
}


#pragma mark - button action
=======
    
}


>>>>>>> 1a6c954171a326696a703f521147367ca20832d1
- (void)hotCategoryBtnAction:(id)sender
{
    UIButton * categoryBtn = (UIButton *)sender;
    NSString * hotString = [self.hotArray objectAtIndex:categoryBtn.tag];
    if (self.taphotCategoryBtnBlock) {
        self.taphotCategoryBtnBlock(hotString);
    }
}

- (void)recordBtnAction:(id)sender
{
    UIButton * recordBtn = (UIButton *)sender;
    NSString * keyword = [self.recentArray objectAtIndex:recordBtn.tag - 324];
    if (self.tapRecordBtnBlock) {
        self.tapRecordBtnBlock(keyword);
    }
}

@end
