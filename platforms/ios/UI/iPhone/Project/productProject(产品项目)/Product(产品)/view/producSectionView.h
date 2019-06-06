//
//  producSectionView.h
//  Boss
//
//  Created by jiangfei on 16/6/1.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^producSectionViewBlock)(BOOL selected);
@interface producSectionView : UIView
/** 监听按钮的点击*/
@property (nonatomic,strong)producSectionViewBlock selectedBlock;
@end
