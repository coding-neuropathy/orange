//
//  SignInView.h
//  orange
//
//  Created by 谢家欣 on 16/8/10.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignInViewDelegate <NSObject>



@end

@interface SignInView : UIView

@property (weak, nonatomic) id<SignInViewDelegate> delegate;

@end
