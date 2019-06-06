//
//  HomePopSelectedStoreView.h
//  Boss
//
//  Created by lining on 16/8/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeSelectedStoreDelegate <NSObject>
@optional
- (void)didSelectedStore:(CDStore *)store;

@end

@interface HomePopSelectedStoreView : UIView<UITableViewDataSource,UITableViewDelegate>

+ (instancetype)createView;
@property (strong, nonatomic) IBOutlet UIButton *bgBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger selectedIdx;
@property (weak, nonatomic) id<HomeSelectedStoreDelegate>delegate;
@property (strong, nonatomic) CDStore *store;

- (void)show;
- (void)hide;

@end
