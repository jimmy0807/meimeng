//
//  UIView+LoadNib.h
//  Boss
//
//  Created by lining on 15/10/21.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LoadNib)

+ (instancetype) loadFromNib;
+ (instancetype) loadNibNamed:(NSString *)nibName;

@end
