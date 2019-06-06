//
//  MemberCardDetailViewController.h
//  Boss
//
//  Created by mac on 15/7/25.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberCardDetailViewController : ICCommonViewController
@property(nonatomic,strong)CDMemberCard *card;
@property(nonatomic,strong)NSArray *itemArray;
@property(nonatomic,strong)NSMutableArray *cardInfoArray;
@property(nonatomic,strong)NSMutableArray *cardTypeArray;

-(void)getData;

@end
