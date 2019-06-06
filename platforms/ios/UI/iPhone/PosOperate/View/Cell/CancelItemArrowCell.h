//
//  CancelItemArrowCell.h
//  Boss
//
//  Created by lining on 16/9/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CancelItemArrowCellDelegate <NSObject>

@optional
- (void)didCancelBtnPressedAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CancelItemArrowCell : UITableViewCell
@property (strong, nonatomic) id<CancelItemArrowCellDelegate>delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UILabel *middleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lineImgView;

@end
