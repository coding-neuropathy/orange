//
//  NoteCell.h
//  orange
//
//  Created by 谢家欣 on 15/10/19.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteCell : UICollectionViewCell

@property (strong, nonatomic) GKNote * note;
@property (strong, nonatomic) UIImageView * imageView;

@end
