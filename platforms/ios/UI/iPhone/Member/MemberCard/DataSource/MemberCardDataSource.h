//
//  MemberCardDataSource.h
//  Boss
//
//  Created by lining on 16/3/25.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MemberCardDataSourceDelegate <NSObject>
- (void)didSelectctdedMemberCard:(CDMemberCard *)memberCard;
@end

@interface MemberCardDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *memberCards;
@property (nonatomic, weak) id<MemberCardDataSourceDelegate>delegate;
@end
