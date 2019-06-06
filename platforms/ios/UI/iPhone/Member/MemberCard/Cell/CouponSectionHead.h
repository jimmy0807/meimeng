//
//  CouponSectionHead.h
//  Boss
//
//  Created by lining on 16/8/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponSectionHead : UIView
+ (instancetype)createView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@end
