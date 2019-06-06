//
//  GivePopupSelectWXGiveType.h
//  Boss
//
//  Created by jimmy on 16/6/1.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GivePopupSelectWXGiveType : UIView

+ (instancetype)showWithNavigationController:(UINavigationController*)navigationController member:(CDMember*)member wxCardTemplates:(NSArray*)wxCardTemplates;

@end
