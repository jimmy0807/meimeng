//
//  BottomPayView.h
//  Boss
//
//  Created by jiangfei on 16/6/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BottomPayViewBlock)(NSInteger tag);

@protocol BottomPayViewDelegate <NSObject>
@optional
- (void)didGuaDanOperate:(CDPosOperate *)operate;
- (void)didPayOperate:(CDPosOperate *)operate;
- (void)didShopCartOperate:(CDPosOperate *)operate;
@end

@interface BottomPayView : UIView
+ (instancetype) createView;
@property (weak, nonatomic) IBOutlet UIButton *gudanBtn;
@property (nonatomic, weak) id<BottomPayViewDelegate>delegate;
@property (nonatomic, strong) CDPosOperate *operate;

@end
