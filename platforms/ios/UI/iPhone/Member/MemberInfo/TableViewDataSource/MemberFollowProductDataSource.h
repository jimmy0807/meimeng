//
//  MemberFollowProductDataSource.h
//  Boss
//
//  Created by lining on 16/5/10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionTableDataSource.h"

@interface MemberFollowProductDataSource : CollectionTableDataSource<UITableViewDataSource,UITableViewDelegate>
//@property (strong, nonatomic) CDMemberFollow *follow;
@property (strong, nonatomic) NSArray *mainProducts;
@property (strong, nonatomic) NSArray *otherProducts;
@end
