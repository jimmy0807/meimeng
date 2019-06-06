//
//  PadPaymodeParams.h
//  Boss
//
//  Created by XiaXianBing on 16/1/25.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PadPaymodeParams : NSObject

@property (nonatomic, assign) BOOL isCash;
@property (nonatomic, assign) BOOL isBank;
@property (nonatomic, assign) BOOL isPoint;
@property (nonatomic, assign) BOOL isDisable;
@property (nonatomic, assign) BOOL didEdited;
@property (nonatomic, assign) BOOL isMemberCard;
@property (nonatomic, assign) BOOL isCouponCard;
@property (nonatomic, assign) CGFloat maxAmount;
@property (nonatomic, assign) CGFloat currentAmount;
@property (nonatomic, assign) CGFloat memberCardAmount;
@property (nonatomic, assign) CGFloat couponCardAmount;
@property (nonatomic, assign) CGFloat pointAmount;


@end
