//
//  MemberCardOperateDataSource.h
//  Boss
//
//  Created by lining on 16/4/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberRecordDataSourceProtocol.h"

@interface MemberCardOperateDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *operates;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, weak) id<MemberRecordDataSourceProtocol>delegate;
@end
