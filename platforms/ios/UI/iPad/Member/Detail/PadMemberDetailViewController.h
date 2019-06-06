//
//  PadMemberDetailViewController.h
//  Boss
//
//  Created by XiaXianBing on 2016-4-12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface PadMemberDetailViewController : ICCommonViewController

- (id)initWithMember:(CDMember *)member;

- (void)refreshWithMember:(CDMember *)member;

@end
