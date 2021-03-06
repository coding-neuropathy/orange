//
//  EmbedReaderViewController.m
//  orange
//
//  Created by 谢家欣 on 16/8/8.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "EmbedReaderViewController.h"
#import "ZBarReaderView.h"
#import "ScannerCropView.h"

#import "EntitySKUController.h"

#import <AVFoundation/AVFoundation.h>


@interface EmbedReaderViewController () <ZBarReaderViewDelegate>
{
@private
    CGFloat yOffset;
}
@property (strong, nonatomic) ScannerCropView   *cropView;
@property (strong, nonatomic) ZBarReaderView    *reader;
@property (strong, nonatomic) UILabel           *infoLabel;
@property (strong, nonatomic) UIButton          *backBtn;

@property (strong, nonatomic) NSString          *text;

@property (strong, nonatomic) AVAudioPlayer     *audioPlayer;

@end


@implementation EmbedReaderViewController


#pragma mark - lazy load
- (ScannerCropView *)cropView
{
    if (!_cropView) {
        _cropView = [[ScannerCropView alloc] initWithFrame:CGRectZero];
        
    }
    return _cropView;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn                    = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.deFrameSize        = CGSizeMake(32., 44.);
        
        [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (AVAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
//        _audioPlayer =
        NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
//        NSLog(@"url %@", beepFilePath);
        NSURL *beepURL = [NSURL URLWithString:beepFilePath];
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
        
        if (error) {
            DDLogError(@"Error: %@", [error localizedDescription]);
        } else
            [_audioPlayer prepareToPlay];
    }
    return _audioPlayer;
}


#pragma mark - init view
- (ZBarReaderView *)reader
{
    if (!_reader) {
        _reader = [ZBarReaderView new];
        
        _reader.readerDelegate = self;
        _reader.frame = [[UIScreen mainScreen] bounds];
        
        [_reader.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:1];
        
        [_reader addSubview:self.cropView];
    
//        if ()
        self.cropView.frame = CGRectMake(0., 0., 258, 258.);
        self.cropView.deFrameLeft = (self.view.deFrameWidth - self.cropView.deFrameWidth) / 2.;
        yOffset = (kScreenHeight - 64 - self.cropView.deFrameHeight) / 2.;
        
        self.cropView.deFrameTop = yOffset;
        
        float A = self.cropView.frame.origin.y / _reader.bounds.size.height;
        float B = 1 - (self.cropView.frame.origin.x + self.cropView.deFrameWidth) / _reader.bounds.size.width;
        float C = (self.cropView.frame.origin.y + self.cropView.frame.size.height) / _reader.bounds.size.height;
        float D = 1 - self.cropView.frame.origin.x / _reader.bounds.size.width;
        [_reader setScanCrop:CGRectMake(A, B, C, D)];
        
    }
    return _reader;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.font = [UIFont systemFontOfSize:14.];
        _infoLabel.textColor = UIColorFromRGB(0xbdbdbd);
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.text = @"将二维码放入框内，即可扫描";
        
    }
    return _infoLabel;
}

- (void)loadView
{
    [super loadView];
    
//    self.view.backgroundColor = [UIColor colorWithHue:0. saturation:0. brightness:0. alpha:0.8];
    [self.view addSubview:self.reader];
    
    [self.view insertSubview:self.infoLabel aboveSubview:self.reader];
    self.infoLabel.frame = CGRectMake(0., 0., kScreenWidth, 20.);
    self.infoLabel.deFrameTop = self.cropView.deFrameBottom + 22.;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTable(@"scanner", kLocalizedFile, nil);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.reader start];
    [self.cropView startAnimating];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.reader stop];
    [self.cropView stopAnimating];
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"QRCodeView"];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"QRCodeView"];
    [super viewWillDisappear:animated];
}

#pragma mark - button action
- (void)backBtnAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <ZBarReaderViewDelegate>
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for(ZBarSymbol *sym in symbols) {
        self.text = sym.data;
        [self.audioPlayer play];
        [self.cropView stopAnimating];
        DDLogInfo(@"scanner result %@", self.text);
        
//        [self.text has]
        NSString *parten = @"^http://\\w+.guoku.com/detail/(\\w+)/";
        NSError * error;
        NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:&error];

        NSTextCheckingResult *match = [reg firstMatchInString:self.text options:0. range:NSMakeRange(0., [self.text length])];
        if (match) {
            NSRange firstHalfRange = [match rangeAtIndex:1];
            DDLogInfo(@"first %@", [self.text substringWithRange:firstHalfRange]);
            NSString * entity_hash = [self.text substringWithRange:firstHalfRange];
            EntitySKUController * vc = [[EntitySKUController alloc] initWithEntityHash:entity_hash];
            
            
//            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController pushViewController:vc animated:YES];
//            [self presentViewController:nav animated:YES completion:nil];
            
        } else {
            [[OpenCenter sharedOpenCenter] openWebWithURL:[NSURL URLWithString:self.text]];
        }
        break;
    }
}


@end
