//
//  BSOverdraft.h
//  Boss
//
//  Created by XiaXianBing on 15/8/20.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSOverdraft : NSObject

@property (nonatomic, strong) NSNumber *overdraftID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, strong) NSString *remark;

@end
