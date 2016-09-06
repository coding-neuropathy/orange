//
//  UIImage+QRCode.m
//  orange
//
//  Created by 谢家欣 on 16/9/6.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "UIImage+QRCode.h"

@implementation UIImage (QRCode)


+ (CIImage *)createQRForString:(NSString *)qrString {
    // 1.将字符串转换为UTF8编码的NSData对象
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    //    DDLogInfo(@"%@", stringData);
    // 2.创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 3.设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 4.返回CIImage
    return qrFilter.outputImage;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image
                                                    size:(CGFloat)size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent),
                        size/CGRectGetHeight(extent));
    // 1.创建一个位图图像，绘制到其大小的位图上下文
    size_t width        = CGRectGetWidth(extent) * scale;
    size_t height       = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs  = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil,
                                                   width,
                                                   height,
                                                   8,
                                                   0,
                                                   cs,
                                                   (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context     = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.创建具有内容的位图图像
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // 3.清理
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (UIImage *)generatorQRCodeImageWithQString:(NSString *)string Width:(CGFloat)width
{
    UIImage *image = [UIImage new];
    CIImage *ciimage = [UIImage createQRForString:string];
    if (ciimage) {
        image = [UIImage createNonInterpolatedUIImageFormCIImage:ciimage size:width];
        
//        return image;
    }
    return image;
}

@end
