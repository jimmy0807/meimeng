//
//  MemberMarkCell.h
//  Boss
//
//  Created by lining on 16/4/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberMarkCell : UITableViewCell
+ (instancetype)createCell;
@property (strong, nonatomic) IBOutlet UITextView *markTextView;

@end
