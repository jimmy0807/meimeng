//
//  CountCell.h
//  Boss
//
//  Created by lining on 16/7/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CountCellDelegate <NSObject>
@optional
- (void)didCountChanged:(NSInteger)count;
@end

@interface CountCell : UITableViewCell

+ (instancetype)createCell;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lineImgView;

@property (nonatomic, assign) NSInteger count;
@property (assign, nonatomic) NSInteger maxCount;
@property (assign, nonatomic) NSInteger minCount;

@property (weak, nonatomic) id<CountCellDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIButton *reduceBtn;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@end
