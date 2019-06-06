//
//  SettingViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/4/2.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface SettingViewController : ICCommonViewController
@property(nonatomic, assign)BOOL didUpdateImage;
@property(nonatomic, strong)UITableView *infoTableView;
@property(nonatomic, strong)NSMutableArray *profileInfoArray;
@property(nonatomic ,strong)NSString *imageName;
-(NSMutableArray *)profileInfoArray;

@end
