//
//  BSPayModeCell.h
//  Boss
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "MemberPay.h"
#import "BSEditCell.h"
@class BSPayModeCell;
@protocol BSPayModeCellDelegate <NSObject>
@optional
-(void)cellWillEdit:(BSPayModeCell *)cell;
-(void)cellDidEdit:(BSPayModeCell *)cell;
@end

@interface BSPayModeCell : BSEditCell
@property(nonatomic,strong)MemberPay *memberPay;
@property(nonatomic,weak)id<BSPayModeCellDelegate>delegate;
-(void)setMemberPay:(MemberPay *)memberPay;
@end
