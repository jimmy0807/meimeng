//
//  ProductTypeNavigationView.h
//  Boss
//
//  Created by jiangfei on 16/5/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductTypeNavigationViewDelegate <NSObject>

@optional
/**
 *  导航按钮点击
 */
-(void)naviBtnClickWithBtnTage:(NSInteger)tag;

@end
@interface ProductTypeNavigationView : UIView
/** delegate*/
@property (nonatomic,weak)id<ProductTypeNavigationViewDelegate> delegate;
/**  imageHide*/
@property (nonatomic,assign)BOOL imageHide;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
+(instancetype)createView;
@end
