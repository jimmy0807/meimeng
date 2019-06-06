//
//  CombinMoreSetFootView.h
//  Boss
//
//  Created by jiangfei on 16/7/15.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CombinMoreSetFootViewBlock)(BOOL isShow);
@interface CombinMoreSetFootView : UIView
+(instancetype)combinFootView;
/** block*/
@property (nonatomic,strong)CombinMoreSetFootViewBlock footBlock;
/**  isShow*/
@property (nonatomic,assign)BOOL isShow;
@end
