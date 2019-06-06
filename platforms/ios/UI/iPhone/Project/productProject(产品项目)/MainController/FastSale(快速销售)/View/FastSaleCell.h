//
//  FastSaleCell.h
//  Boss
//
//  Created by jiangfei on 16/7/5.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FastSaleCellDelegate <NSObject>
@optional
-(void)fastSaleCellDidSelectedWithBtnTitle:(NSString*)titleName;

@end

@interface FastSaleCell : UICollectionViewCell

/** titleName*/
@property (nonatomic, strong)NSString *titleName;
@property (nonatomic, strong)UIColor *titleColor;

/** delegate*/
@property (nonatomic,weak)id<FastSaleCellDelegate>delegate;

@end
