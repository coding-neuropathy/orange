//
//  BioViewController.h
//  orange
//
//  Created by D_Collin on 16/5/5.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "BaseViewController.h"

@protocol BioViewControllerDelegate <NSObject>

- (void)reloadData;

@end

@interface BioViewController : BaseViewController

@property (nonatomic , weak)id <BioViewControllerDelegate> delegate;

@end
