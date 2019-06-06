//
//  MemberCardPointDataSource.h
//  Boss
//
//  Created by lining on 16/4/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberRecordDataSourceProtocol.h"

@interface MemberCardPointDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *points;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, weak) id<MemberRecordDataSourceProtocol>delegate;
@end
