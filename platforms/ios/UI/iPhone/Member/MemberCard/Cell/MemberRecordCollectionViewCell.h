//
//  MemberRecordCollectionViewCell.h
//  Boss
//
//  Created by lining on 16/3/28.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MemberRecordCollectionViewCell;
@protocol CollectionViewCellDelegate <NSObject>

@optional
- (void)didAddBtnPressedOfCell:(MemberRecordCollectionViewCell *)cell;

@end

@interface MemberRecordCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *noRecordView;
@property (strong, nonatomic) IBOutlet UIImageView *noRecordImg;
@property (strong, nonatomic) IBOutlet UILabel *noRecordLabel;
@property (assign, nonatomic) BOOL addBtnHidden;

@property (strong, nonatomic) NSString *cellTag;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) id<CollectionViewCellDelegate>delegate;

- (IBAction)addBtnPressed:(id)sender;

@end
