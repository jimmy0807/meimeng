//
//  MemberChangeShopDataSource.h
//  Boss
//
//  Created by lining on 16/5/3.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberRecordDataSourceProtocol.h"

@interface MemberChangeShopDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *changeShops;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, weak) id<MemberRecordDataSourceProtocol>delegate;
@end
