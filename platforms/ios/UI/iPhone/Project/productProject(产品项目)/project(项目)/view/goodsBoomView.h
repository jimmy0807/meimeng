//
//  goodsBoomView.h
//  Boss
//
//  Created by jiangfei on 16/6/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class goodsBoomView;
@protocol goodsBoomViewDelegate <NSObject>
@optional
-(void)goodsBoomViewAddBtnClick;

@end
@interface goodsBoomView : UIView
/** delegate*/
@property (nonatomic,weak)id<goodsBoomViewDelegate>delegate;
@end
