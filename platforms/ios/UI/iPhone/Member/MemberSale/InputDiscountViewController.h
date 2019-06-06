//
//  InputDiscountViewController.h
//  Boss
//
//  Created by lining on 16/8/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@protocol InputDiscountViewControllerDelegate <NSObject>
@optional
- (void) inputDiscountDone:(CGFloat)discount;
@end

@interface InputDiscountViewController : ICCommonViewController
@property (strong, nonatomic) IBOutlet UITextField *discountTextField;
@property (nonatomic,weak) id<InputDiscountViewControllerDelegate>delegate;

@end
