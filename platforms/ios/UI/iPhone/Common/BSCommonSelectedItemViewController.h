//
//  BSCommonSelectedItemViewController.h
//  Boss
//
//  Created by jimmy on 15/7/3.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
@class BSCommonSelectedItemViewController;

@protocol BSCommonSelectedItemViewControllerDelegate <NSObject>
@required
-(void)didSelectItemAtIndex:(NSInteger)index userData:(id)userData;
@optional
-(void)didAddButtonPressed:(id)userData;
-(void)willReloadViewController:(BSCommonSelectedItemViewController *)contoller;
@end

@interface BSCommonSelectedItemViewController : ICCommonViewController

@property(nonatomic, strong)NSMutableArray* dataArray;
@property(nonatomic)NSInteger currentSelectIndex;
@property(nonatomic)id userData;
@property(nonatomic)BOOL* hasAddButton;
@property(nonatomic, weak)id<BSCommonSelectedItemViewControllerDelegate> delegate;
@property(nonatomic, strong) NSString *notificationName;

- (void)reloadData;

@end
