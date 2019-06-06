//
//  PaymentCell.h
//  Boss
//
//  Created by lining on 16/6/13.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaymentCell;
@protocol PaymentCellDelegate <NSObject>
@optional
- (void)didCancelBtnPressed:(PaymentCell *)cell;

@end

@interface PaymentCell : UITableViewCell

+ (instancetype)createCell;

@property (weak,nonatomic)id<PaymentCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) CGFloat amount;
@property (strong, nonatomic) NSObject *payMode;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)cancelBtnPressed:(UIButton *)sender;

@end
