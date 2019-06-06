//
//  TemplateCell.h
//  Boss
//
//  Created by lining on 16/4/15.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemplateCell : UITableViewCell

+ (instancetype)createCell;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end
