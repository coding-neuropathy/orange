//
//  EntityNoteFooterView.m
//  orange
//
//  Created by 谢家欣 on 16/9/15.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "EntityNoteFooterView.h"

@interface EntityNoteFooterView ()

@property (strong, nonatomic) UIButton * noteButton;

@end

@implementation EntityNoteFooterView

- (UIButton *)noteButton
{
    if (!_noteButton) {
        _noteButton                     = [UIButton buttonWithType:UIButtonTypeCustom];
        _noteButton.deFrameSize         = CGSizeMake(self.deFrameWidth - 32., 50.);
        _noteButton.layer.cornerRadius  = _noteButton.deFrameHeight / 2.;
        _noteButton.layer.masksToBounds = YES;
        _noteButton.layer.borderColor   = [UIColor colorFromHexString:@"#e6e6e6"].CGColor;
        _noteButton.layer.borderWidth   = 1.;
        _noteButton.titleLabel.font     = [UIFont fontWithName:@"PingFangSC-Semibold" size:17.];
        
        [_noteButton setImage:[UIImage imageNamed:@"post note"] forState:UIControlStateNormal];
        [_noteButton setTitleColor:[UIColor colorFromHexString:@"#757575"] forState:UIControlStateNormal];
        [_noteButton setTitle:NSLocalizedStringFromTable(@"post note", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_noteButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#f8f8f8"] andSize:_noteButton.deFrameSize] forState:UIControlStateNormal];
        [_noteButton addTarget:self action:@selector(noteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_noteButton];
    }
    return _noteButton;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.noteButton.deFrameTop  = 20.;
    self.noteButton.deFrameLeft = 16.;
}

#pragma mark - button action
- (void)noteButtonAction:(id)sender
{
    if (self.openPostNote) {
        self.openPostNote();
    }
}

@end
