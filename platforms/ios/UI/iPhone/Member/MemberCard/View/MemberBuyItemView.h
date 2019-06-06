//
//  MemberBuyItemView.h
//  Boss
//
//  Created by lining on 16/6/21.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberBuyItemView : UIView
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UIButton *reduceBtn;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;

@property (strong, nonatomic) IBOutlet UILabel *countLabel;

- (IBAction)reduceBtnPressed:(id)sender;
- (IBAction)addBtnPressed:(id)sender;


- (IBAction)cancelBtnPressed:(id)sender;
- (IBAction)sureBtnPressed:(id)sender;

@end
