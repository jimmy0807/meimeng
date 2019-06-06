//
//  ProductCountView.h
//  Boss
//
//  Created by lining on 15/6/25.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductCountView;
@protocol ProductCountViewDelegate <UITextFieldDelegate>
@optional
-(void)countChanged:(ProductCountView *)countView;
@end

@interface ProductCountView : UIView
- (id)initWithPoint:(CGPoint)point count:(NSInteger)count;
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, assign) id<ProductCountViewDelegate>delegate;
@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, assign) NSInteger maxCount;
@property(nonatomic, assign) NSInteger minCount;
@property(nonatomic, strong) UITextField *countField;
@end
