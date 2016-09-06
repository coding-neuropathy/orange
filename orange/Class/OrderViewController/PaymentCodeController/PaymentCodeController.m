//
//  PaymentCodeController.m
//  orange
//
//  Created by 谢家欣 on 16/9/6.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "PaymentCodeController.h"

@interface PaymentCodeController ()

@property (strong, nonatomic) UIImageView   *QRCodeImageView;
@property (strong, nonatomic) NSString      *qString;

@end

@implementation PaymentCodeController

- (instancetype)initWithQString:(NSString *)q_string
{
    self = [super init];
    if (self) {
        self.qString    = q_string;
    }
    return self;
}

#pragma mark - lazy load View
- (UIImageView *)QRCodeImageView
{
    if (!_QRCodeImageView) {
        _QRCodeImageView                    = [[UIImageView alloc] initWithFrame:CGRectZero];
        _QRCodeImageView.deFrameSize        = CGSizeMake(200., 200.);
        _QRCodeImageView.backgroundColor    = [UIColor redColor];
        _QRCodeImageView.contentMode        = UIViewContentModeScaleAspectFit;
    }
    return _QRCodeImageView;
}

- (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding: NSISOLatin1StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    
    return qrFilter.outputImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.QRCodeImageView];
    
    UIImage *qr_image           = [UIImage imageWithCGImage:(__bridge CGImageRef _Nonnull)([self createQRForString:self.qString])];
    self.QRCodeImageView.image  = qr_image;
    self.QRCodeImageView.center = self.view.center;
}

@end
