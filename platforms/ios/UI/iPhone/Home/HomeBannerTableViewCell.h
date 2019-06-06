//
//  HomeBannerTableViewCell.h
//  Boss
//
//  Created by jimmy on 15/7/2.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeBannerTableViewCell;

@protocol HomeBannerTableViewCellDelegate <NSObject>
- (void)didSettingStoreButtonPressed:(HomeBannerTableViewCell*)cell store:(CDStore*)store;
- (void)didAdvertisementButtonPressed:(HomeBannerTableViewCell*)cell linkUrl:(NSString*)linkUrl;
- (void)didTodayIncomeButtonPressed:(HomeBannerTableViewCell*)cell;
- (void)didPassengerFlowButtonPressed:(HomeBannerTableViewCell*)cell;
- (void)didMyTodayInComeButtonPressed:(HomeBannerTableViewCell*)cell;
- (void)didMyTodayAppointmentButtonPressed:(HomeBannerTableViewCell*)cell;
@end

@interface HomeBannerTableViewCell : UITableViewCell

@property(nonatomic, weak)id<HomeBannerTableViewCellDelegate> delegate;

- (void)reloadData;

@end
