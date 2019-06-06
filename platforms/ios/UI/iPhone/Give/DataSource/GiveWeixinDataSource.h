//
//  GiveWeixinDataSource.h
//  Boss
//
//  Created by lining on 16/9/21.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GiveWeixinDataSourceDelegate <NSObject>
@optional
- (void)didWeixinTemplatedPressed:(CDWXCardTemplate *)wxTemplate;
@end

@interface GiveWeixinDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) id<GiveWeixinDataSourceDelegate>delegate;
- (void) reloadData;
@end
