//
//  CouponProject.h
//  Boss
//
//  Created by lining on 15/11/23.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponProject : NSObject

@property (strong, nonatomic) CDProjectItem *item;
@property (assign, nonatomic) NSInteger count;

- (instancetype) initWithItem:(CDProjectItem *)item;

@end

