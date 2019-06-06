//
//  GiveCell.h
//  Boss
//
//  Created by lining on 15/10/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GiveCellDelegate <NSObject>
@optional
- (void)didDeleteBtnPressedAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface GiveCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;

@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (Weak, nonatomic) id<GiveCellDelegate>delegate;

+ (instancetype) createCell;
- (void)itemWithName:(NSString *)name;
- (void)itemWithName:(NSString *)name count:(NSString *)count;
- (void)lastItem;
- (void)hideDeleteView:(bool)hidden;
- (IBAction)deleteBtnPressed:(UIButton *)sender;

@end
