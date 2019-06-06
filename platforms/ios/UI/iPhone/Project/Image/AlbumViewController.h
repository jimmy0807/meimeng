//
//  AlbumViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/19.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@protocol AlbumViewControllerDelegate <NSObject>

- (void)didAlbumImageEditFinished:(UIImage *)image;

@end

@interface AlbumViewController : ICCommonViewController <UIScrollViewDelegate>

- (id)initWithAlbumImage:(UIImage *)image delegate:(id<AlbumViewControllerDelegate>)delegate;

@end
