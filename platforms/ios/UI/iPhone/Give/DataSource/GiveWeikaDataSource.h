//
//  GiveWeikaDataSource.h
//  Boss
//
//  Created by lining on 16/9/21.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GiveWeikaDataSourceDelegate <NSObject>
@optional
- (void)didWeikaTemplatePressed:(CDCardTemplate *)weikaTemplate;
@end

@interface GiveWeikaDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property(weak, nonatomic) id<GiveWeikaDataSourceDelegate>delegate;
- (void)reloadData;
@end
