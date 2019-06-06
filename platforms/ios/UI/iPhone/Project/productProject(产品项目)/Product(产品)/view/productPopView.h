//
//  prodcutPopView.h
//  Boss
//
//  Created by jiangfei on 16/6/3.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^productPopViewBlock)(NSString *seletedCell,NSInteger tag);
@interface productPopView : UIView
+(instancetype)productPopView;
/**把选中的cell的title传递给Controller*/
@property (nonatomic,strong)productPopViewBlock popBlock;
/** pop显示的数组("产品",@"项目"...)*/
@property (nonatomic,strong)NSMutableArray *titleNameArray;
/** seletedName*/
@property (nonatomic,strong)NSString *seletedName;
@end
