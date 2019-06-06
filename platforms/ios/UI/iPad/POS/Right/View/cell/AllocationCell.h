//
//  AllocationCell.h
//  Boss
//
//  Created by lining on 15/10/21.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllocationCellDelegate <NSObject>
@optional
- (void)didDeleteBtnPressed:(NSIndexPath *)indexPath;
@end

@interface AllocationCell : UITableViewCell

+ (instancetype)createCell;
@property (Weak, nonatomic) id<AllocationCellDelegate>delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UIButton *removeBtn;

- (IBAction)deleteBtnPressed:(id)sender;
@end
