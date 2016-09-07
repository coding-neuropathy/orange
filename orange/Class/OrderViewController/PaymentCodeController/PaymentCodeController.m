//
//  PaymentCodeController.m
//  orange
//
//  Created by 谢家欣 on 16/9/6.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "PaymentCodeController.h"
#import "UIImage+QRCode.h"

@interface PaymentCodeController ()

@property (strong, nonatomic) UIImageView   *QRCodeImageView;
//@property (strong, nonatomic) NSString      *qString;
@property (strong, nonatomic) GKOrder       *order;

@end

@implementation PaymentCodeController

//- (instancetype)initWithQString:(NSString *)q_string
//{
//    self = [super init];
//    if (self) {
//        self.qString    = q_string;
//    }
//    return self;
//}
- (instancetype)initWithOrder:(GKOrder *)order
{
    self    = [super init];
    if (self) {
        self.order  = order;
    }
    return self;
}

#pragma mark - lazy load View
- (UIImageView *)QRCodeImageView
{
    if (!_QRCodeImageView) {
        _QRCodeImageView                    = [[UIImageView alloc] initWithFrame:CGRectZero];
        _QRCodeImageView.deFrameSize        = CGSizeMake(200., 200.);
//        _QRCodeImageView.transform          = CGAffineTransformMakeScale(0.3, 0.3);
//        _QRCodeImageView.backgroundColor    = [UIColor redColor];
        _QRCodeImageView.contentMode        = UIViewContentModeScaleAspectFit;
    }
    return _QRCodeImageView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor   = [UIColor colorWithWhite:0. alpha:.45];
    [self.view addSubview:self.QRCodeImageView];
    
    self.QRCodeImageView.center = self.view.center;
    
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTable(@"loading", kLocalizedFile, nil)];
    [API getPaymentURLWithOrderId:self.order.orderId PaymentType:WechatPaymentType Success:^(NSString *payment_url) {
        self.QRCodeImageView.image  = [UIImage generatorQRCodeImageWithQString:payment_url Width:self.QRCodeImageView.deFrameWidth];
        self.QRCodeImageView.transform = CGAffineTransformMakeScale(1. * 0, 1. * 0);
        [SVProgressHUD dismissWithCompletion:^{
            [self fadeIn];
        }];
    } Failure:^(NSInteger stateCode, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [self fadeOutWithAction:self.closeAction];
    }];
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.closeAction)
        [self fadeOutWithAction:self.closeAction];
    else
        [self fadeOutWithAction:nil];
}

- (void)fadeIn
{
//    self.QRCodeImageView.transform = CGAffineTransformMakeScale(1. * 0.5, 1. * 0.5);
    [UIView animateWithDuration:0.3 animations:^{
        self.QRCodeImageView.transform = CGAffineTransformMakeScale(1., 1.);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)fadeOutWithAction:(void (^)(void))action
{
    [UIView animateWithDuration:0.3 animations:^{
        self.QRCodeImageView.transform = CGAffineTransformMakeScale(1. * 0.1, 1. * 0.1);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
            self.closeAction();
        }
    }];
}


@end
