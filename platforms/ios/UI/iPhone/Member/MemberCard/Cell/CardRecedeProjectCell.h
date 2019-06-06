//
//  CardRecedeProjectCell.h
//  Boss
//
//  Created by lining on 16/4/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardRecedeProjectCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@property (assign, nonatomic) NSInteger maxCount;
@property (assign, nonatomic) NSInteger minCount;

@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) CGFloat money;


+ (instancetype) createCell;

- (IBAction)reduceBtnPressed:(id)sender;
- (IBAction)addBtnPressed:(id)sender;

@end
