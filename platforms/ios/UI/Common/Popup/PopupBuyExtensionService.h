//
//  PopupBuyExtensionService.h
//  Boss
//
//  Created by jimmy on 16/3/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupBuyExtensionService : UIView

@property(nonatomic, weak)UINavigationController* navigationController;
@property(nonatomic, strong)NSString* url;

+ (instancetype)show;
+ (instancetype)showWithNavigationController:(UINavigationController*)navigationController url:(NSString*)url;

@end
