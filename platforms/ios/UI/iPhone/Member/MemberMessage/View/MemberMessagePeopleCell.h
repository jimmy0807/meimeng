//
//  MemberMessagePeopleCell.h
//  Boss
//
//  Created by lining on 16/5/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberMessagePeopleCell : UITableViewCell

+ (instancetype) createCell;
@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *IDLabel;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImgView;

@end
