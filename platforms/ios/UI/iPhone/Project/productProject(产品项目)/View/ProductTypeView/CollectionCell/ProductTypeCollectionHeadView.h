//
//  ProductTypeCollectionHeadView.h
//  Boss
//
//  Created by jiangfei on 16/5/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ProductTypeCollectionHeadViewDelegate <NSObject>
@optional
- (void)didSearchWithString:(NSString *)string;
- (void)didChangeBtnPressed:(BOOL)isOneColumn;
- (void)didScanBtnPressed;

@end


@interface ProductTypeCollectionHeadView : UICollectionReusableView
+ (instancetype)createView;

@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (nonatomic,weak)id <ProductTypeCollectionHeadViewDelegate> delegate;
@property (nonatomic, strong) NSString *placeholder;
@end
