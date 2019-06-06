//
//  BSReturnItem.h
//  Boss
//
//  Created by XiaXianBing on 2016-3-10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSReturnItem : NSObject

@property (nonatomic, assign) NSInteger returnCount;
@property (nonatomic, assign) CGFloat returnAmount;
@property (nonatomic, strong) CDMemberCardProject *cardProject;
@property (nonatomic, strong) CDProjectItem *item;

@end
