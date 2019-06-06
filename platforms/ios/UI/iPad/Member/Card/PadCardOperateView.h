//
//  PadCardOperateView.h
//  Boss
//
//  Created by XiaXianBing on 15/11/11.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PadCardOperateView;
@protocol PadCardOperateViewDelegate <NSObject>

- (void)didMemberCardOperateWithType:(NSInteger)type;

@end

@interface PadCardOperateView : UIView

@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, assign) id<PadCardOperateViewDelegate> delegate;

@end
