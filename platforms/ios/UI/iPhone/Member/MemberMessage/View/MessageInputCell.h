//
//  MessageInputCell.h
//  Boss
//
//  Created by lining on 16/6/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageInputCell : UITableViewCell
+ (instancetype)createCell;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@end
