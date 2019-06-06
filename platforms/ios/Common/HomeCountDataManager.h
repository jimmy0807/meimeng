//
//  HomeCountDataManager.h
//  Boss
//
//  Created by jimmy on 15/7/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeCountDataManager : NSObject

InterfaceSharedManager(HomeCountDataManager);

- (void)fetchData;

@property(nonatomic, strong)NSArray* userIDs;
@property(nonatomic, strong)NSNumber* period;

@end
