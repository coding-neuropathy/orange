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
#import <AVFoundation/AVFoundation.h>


@interface EmbedReaderViewController () <ZBarReaderViewDelegate>
{
@private
    CGFloat yOffset;
}
@property (strong, nonatomic) ScannerCropView * cropView;
@property (strong, nonatomic) ZBarReaderView * reader;
@property (strong, nonatomic) NSString * text;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end


@implementation EmbedReaderViewController

- (ScannerCropView *)cropView
{
    if (!_cropView) {
        _cropView = [[ScannerCropView alloc] initWithFrame:CGRectZero];
        
    }
    return _cropView;
}
#pragma mark
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

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithHue:0. saturation:0. brightness:0. alpha:0.8];
    [self.view addSubview:self.reader];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.reader start];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.reader stop];
    [self.audioPlayer stop];
    [super viewDidDisappear:animated];
}


#pragma mark - <ZBarReaderViewDelegate>
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for(ZBarSymbol *sym in symbols) {
        self.text = sym.data;
//        DDLogError(@"%@", self.text);
        [self.audioPlayer play];
        
        [[OpenCenter sharedOpenCenter] openWebWithURL:[NSURL URLWithString:self.text]];
        break;
    }
}


@end
