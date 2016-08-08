//
//  EmbedReaderViewController.m
//  orange
//
//  Created by 谢家欣 on 16/8/8.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "EmbedReaderViewController.h"
#import "ZBarReaderView.h"

@interface EmbedReaderViewController () <ZBarReaderViewDelegate>

@property (strong, nonatomic) ZBarReaderView * reader;
@property (strong, nonatomic) NSString * text;

@end


@implementation EmbedReaderViewController

- (ZBarReaderView *)reader
{
    if (!_reader) {
        _reader = [ZBarReaderView new];
        
        _reader.readerDelegate = self;
        
    }
    return _reader;
}

- (void)loadView
{
    [super loadView];
    
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
    [super viewDidDisappear:animated];
}


#pragma mark - <ZBarReaderViewDelegate>
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for(ZBarSymbol *sym in symbols) {
        self.text = sym.data;
        break;
    }
}


@end
