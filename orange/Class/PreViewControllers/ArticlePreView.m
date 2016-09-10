//
//  ArticlePreView.m
//  orange
//
//  Created by 谢家欣 on 16/9/3.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "ArticlePreView.h"

@interface ArticlePreView ()

@property (strong, nonatomic) UIImageView   *CoverImageView;
@property (strong, nonatomic) UILabel       *titleLable;
@property (strong, nonatomic) UITextView    *contentText;;


@end

@implementation ArticlePreView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIImageView *)CoverImageView
{
    if (!_CoverImageView) {
        _CoverImageView                     = [[UIImageView alloc] initWithFrame:CGRectZero];
        _CoverImageView.deFrameSize         = CGSizeMake(self.deFrameWidth, self.deFrameWidth / 1.8);
        _CoverImageView.contentMode         = UIViewContentModeScaleAspectFill;
        _CoverImageView.layer.masksToBounds = YES;
//        _CoverImageView.backgroundColor     = [UIColor redColor];
        [self addSubview:_CoverImageView];
    }
    return _CoverImageView;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable                         = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLable.deFrameSize             = CGSizeMake(self.deFrameWidth - 20., 24.);
        _titleLable.numberOfLines           = 2.;
        _titleLable.lineBreakMode           = NSLineBreakByTruncatingTail;
        _titleLable.textColor               = [UIColor colorFromHexString:@"#212121"];
        _titleLable.font                    = [UIFont fontWithName:@"PingFangSC-Semibold" size:20.];
        _titleLable.textAlignment           = NSTextAlignmentLeft;
        
        [self addSubview:_titleLable];
    }
    return _titleLable;
}

- (UITextView *)contentText
{
    if (!_contentText) {
        _contentText                        = [[UITextView alloc] initWithFrame:CGRectZero];
        _contentText.deFrameSize            = CGSizeMake(self.deFrameWidth - 20., 100);
        _contentText.editable               = NO;
        _contentText.scrollEnabled          = NO;
        
        [self addSubview:_contentText];
    }
    return _contentText;
}

- (void)setArticle:(GKArticle *)article
{
    _article                = article;
    self.titleLable.text    = _article.title;
//    DDLogInfo(@"content %@", _article.strip_tags_content);
    [self.CoverImageView sd_setImageWithURL:_article.coverURL
                           placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:self.CoverImageView.deFrameSize] options:SDWebImageRetryFailed];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                            initWithData: [self.article.strip_tags_content dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                            documentAttributes: nil
                                            error: nil
                                            ];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:16.] range:NSMakeRange(0., attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#212121"] range:NSMakeRange(0, attributedString.length)];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
    //行间距
    paragraph.lineSpacing = 5;
    //段落间距
    paragraph.paragraphSpacing = 20;
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, attributedString.length)];
    
    [attributedString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value) {
            //            DDLogInfo(@"%@", value);
            NSTextAttachment * attach = value;
            //            attach.image = [UIImage imageNamed:@"Settings"];
            CGFloat ratio   = (self.deFrameWidth - 20.) / attach.bounds.size.width;
            //            DDLogInfo(@"%f", attach.bounds.size.height);
            attach.bounds = CGRectMake(10, 10, self.deFrameWidth - 20., ratio * attach.bounds.size.height);
//            attach.bounds = CGRectMake(0., 0., 0., 0.);
        }
    }];
    
    self.contentText.attributedText = attributedString;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = [self.titleLable.text heightWithLineWidth:self.titleLable.deFrameWidth Font:self.titleLable.font LineHeight:4.];
    self.titleLable.deFrameHeight   = height;
    self.titleLable.deFrameTop      = self.CoverImageView.deFrameBottom + 10.;
    self.titleLable.deFrameLeft     = 10.;
    
    self.contentText.deFrameHeight  = self.deFrameHeight - self.titleLable.deFrameBottom - 10.;
    self.contentText.deFrameTop     = self.titleLable.deFrameBottom;
    self.contentText.deFrameLeft    = 10.;
    
}

@end
