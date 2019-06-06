//
//  PosOperateBtnCell.h
//  Boss
//
//  Created by lining on 16/9/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BtnCellDelegate <NSObject>
@optional
- (void)didBtnPressed;

@end

@interface PosOperateBtnCell : UITableViewCell
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) id<BtnCellDelegate>delegate;
@end
