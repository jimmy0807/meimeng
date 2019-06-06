//
//  CollectionTableDataSource.h
//  Boss
//
//  Created by lining on 16/5/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberRecordDataSourceProtocol.h"

@interface CollectionTableDataSource : NSObject
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, weak) id<MemberRecordDataSourceProtocol>delegate;
@end
