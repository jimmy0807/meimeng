//
//  PadProjectCart.h
//  Boss
//
//  Created by XiaXianBing on 15/11/6.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PadProjectCart : NSObject

@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) NSInteger localCount;
@property (nonatomic, strong) NSNumber *parentID;
@property (nonatomic, strong) CDProjectItem *item;

- (id)initWithRelated:(CDProjectRelated *)related;

@end
