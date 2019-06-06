//
//  PadBookFloorView.h
//  Boss
//
//  Created by lining on 16/6/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PadBookFloorViewDelegate <NSObject>
@optional
- (void)didSelectedFloor:(CDRestaurantFloor *)floor;
@end

@interface PadBookFloorView : UIView

@property (nonatomic, weak)id<PadBookFloorViewDelegate>delegate;
- (instancetype) initWithFrame:(CGRect)frame floors:(NSArray *)floors;



@end
