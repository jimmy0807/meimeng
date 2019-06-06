//
//  CardPayCell.h
//  Boss
//
//  Created by lining on 16/4/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CardPayCellDelegate <NSObject>

- (void)changeCardPay;

@end

@interface CardPayCell : UITableViewCell

+ (instancetype)createCell;

@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) id<CardPayCellDelegate>delegate;

- (IBAction)changeBtnPressed:(id)sender;

@end
