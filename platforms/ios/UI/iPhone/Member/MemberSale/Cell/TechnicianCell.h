//
//  TechnicianCell.h
//  Boss
//
//  Created by lining on 16/7/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TechnicianCellDelegate <NSObject>
@optional
- (void)didTechnicianArrowBtnSelected:(BOOL)selected;
- (void)didDateBtnSelected:(BOOL)selected;
@end

@interface TechnicianCell : UITableViewCell

+ (instancetype)createCell;

@property (weak, nonatomic) id<TechnicianCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *nameArrow;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *dateArrow;

@end
