//
//  shopController.h
//  Boss
//
//  Created by jiangfei on 16/6/21.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum ShopControllerType
{
    ShopControllerType_Point,      //积分
    ShopControllerType_Buy,        //buy
    
}ShopControllerType;


@protocol ShopProductControllerDelegate <NSObject>
@optional
/** 点击了collection的cell */
-(void)didSelectedProjectItem:(CDProjectItem*)item;

@end

@interface ShopProductController : UIViewController

/** deletage*/
@property (nonatomic,weak)id<ShopProductControllerDelegate>delegate;

/** 控制器的类型 */
@property (nonatomic,assign)ShopControllerType type;


@end
