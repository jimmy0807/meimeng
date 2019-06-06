//
//  MemberCardItemViewController.h
//  Boss
//
//  Created by mac on 15/7/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberCardItemViewController : ICCommonViewController
@property(nonatomic,strong)NSArray *cardProject;
@property(nonatomic,strong)NSNumber *cardID;
@property(nonatomic,strong)NSNumber *memberID;
@property(nonatomic,strong)NSNumber *pricelist_id;
@property(nonatomic,strong)CDMemberCard *card;

- (void)reloaData;
@end
