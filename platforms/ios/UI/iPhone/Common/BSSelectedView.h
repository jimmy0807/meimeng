//
//  BSSelectedView.h
//  Boss
//
//  Created by lining on 16/7/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BSSelectedViewDelegate <NSObject>
@optional
- (void)didSelectedAtIndex:(NSInteger)index;
@end

@interface BSSelectedView : UIView
+ (instancetype)createViewWithTitle:(NSString *)title;
@property (nonatomic, weak) id<BSSelectedViewDelegate>delegate;

@property (nonatomic, strong)NSArray *stringArray;

@property (nonatomic, assign) NSInteger currentSelectedIdx;


- (void)show;
- (void)hide;
@end
