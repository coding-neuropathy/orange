//
//  UIImage+QRCode.h
//  orange
//
//  Created by 谢家欣 on 16/9/6.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QRCode)

+ (UIImage *)generatorQRCodeImageWithQString:(NSString *)string Width:(CGFloat)width;

@end
