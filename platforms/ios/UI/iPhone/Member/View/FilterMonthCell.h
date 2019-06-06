//
//  FilterMonthCell.h
//  Boss
//
//  Created by lining on 16/5/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterMonthCellDelegate <NSObject>
@optional
- (void)didSelectedBtnAtIndex:(NSInteger)index;
@end


@interface FilterMonthCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;
@property (strong, nonatomic) IBOutlet UIButton *button4;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, weak) id<FilterMonthCellDelegate>delegate;

+ (instancetype) createCell;

- (void) setBtnTitle:(NSString *)title atIndex:(NSInteger)index selected:(BOOL)selected;
@end
