//
//  PayModeCell.h
//  Boss
//
//  Created by lining on 16/6/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayModeCellDelegate <NSObject>
@optional
- (void)didPayModeBtnPressed:(CDPOSPayMode *)payMode;
@end

@interface PayModeCell : UITableViewCell

+ (instancetype)createCell;

@property (nonatomic, strong) CDPOSPayMode *payMode;
@property (nonatomic, weak)id<PayModeCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)payBtnPressed:(id)sender;


@end
