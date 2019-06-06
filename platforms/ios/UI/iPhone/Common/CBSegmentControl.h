//
//  CBSegmentControl.h
//  Boss
//
//  Created by lining on 15/6/15.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBSegmentControlDelegate <NSObject>
@optional
-(void)didSegmentCotrolSelectedAtIndex:(NSInteger)index;
@end


@interface CBSegmentControl : UIView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
@property(nonatomic, assign) NSInteger selectedIdx;
@property(nonatomic, assign) id<CBSegmentControlDelegate>delegate;
@end
