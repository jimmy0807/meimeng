//
//  PadReserveViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/12/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"

@protocol PadReserveViewControllerDelegate <NSObject>

- (void)didPadReserveConfirm:(CDBook *)book;

@end


@interface PadReserveViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PadMaskView *maskView;
@property (nonatomic, assign) id<PadReserveViewControllerDelegate> delegate;

- (id)initWithDelegate:(id<PadReserveViewControllerDelegate>)delegate;

@end
