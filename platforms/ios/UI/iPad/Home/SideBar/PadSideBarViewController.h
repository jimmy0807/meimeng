//
//  PadSideBarViewController.h
//  BornPOS
//
//  Created by XiaXianBing on 15/10/8.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICCommonViewController.h"

extern NSInteger kPadSideBarTypePos;
extern NSInteger kPadSideBarTypeReserve;
extern NSInteger kPadSideBarTypeMember;
extern NSInteger kPadSidebarTypeHistory;
extern NSInteger kPadSideBarTypeStatistic;
extern NSInteger kPadSideBarTypeSetting;
extern NSInteger kPadSideBarTypeHospital;
extern NSInteger kPadSideBarTypeCount;

@protocol PadSideBarViewControllerDelegate <NSObject>

- (void)didPadSideBarItemSelected:(NSInteger)type;
- (BOOL)isRootViewController;

@end

@interface PadSideBarViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithDelegate:(id<PadSideBarViewControllerDelegate>)delegate;

- (void)setPadSideBarType:(NSInteger)type;
- (void)reloadData;

@end
