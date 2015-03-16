//
//  RadioButton.h
//  orange
//
//  Created by 谢家欣 on 15/3/16.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioButton : UIButton

@property (nonatomic, strong) NSArray* groupButtons;
@property (nonatomic, readonly) RadioButton* selectedButton;

-(void) setSelected:(BOOL)selected;

-(void) setSelectedWithTag:(NSInteger)tag;

-(void) deselectAllButtons;

@end
