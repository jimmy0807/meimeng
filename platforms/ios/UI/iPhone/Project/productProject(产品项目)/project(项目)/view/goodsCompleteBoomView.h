//
//  goodsCompleteBoomView.h
//  Boss
//
//  Created by jiangfei on 16/6/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^goodsCompleteBoomViewBlock)(UIButton *btn);
@interface goodsCompleteBoomView : UIView
/** block*/
@property (nonatomic,strong)goodsCompleteBoomViewBlock completeBoomBlock;
@end
