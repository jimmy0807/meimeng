//
//  BottomBtnView.h
//  Boss
//
//  Created by jiangfei on 16/6/13.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomBtnViewDelegate <NSObject>

@optional
- (void)didSureBtnPressed;

@end

@interface BottomBtnView : UIView

+ (instancetype)createView;
@property (nonatomic, weak) id<BottomBtnViewDelegate>delegate;
@property (nonatomic,assign) NSUInteger count;

@end
