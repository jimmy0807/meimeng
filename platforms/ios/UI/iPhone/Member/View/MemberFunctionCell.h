//
//  MemberFunctionCell.h
//  Boss
//
//  Created by lining on 16/3/17.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ROW_ITEM_COUNT 3

@protocol MemberFunctionCellDelegate <NSObject>
@optional
- (void)didSelectedItemAtIdx:(NSInteger)idx;

@end

@class FunctionItem;

@interface MemberFunctionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIImageView *img3;
@property (strong, nonatomic) IBOutlet UILabel *label3;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) NSArray *labels;


@property (nonatomic, weak) id<MemberFunctionCellDelegate>delegate;
@property (nonatomic, assign) NSInteger row;

+ (instancetype) createCell;
- (void)setItem:(FunctionItem *)item withIndex:(NSInteger)idx;

- (IBAction)itemButtonPressed:(UIButton *)sender;

@end


@interface FunctionItem : NSObject
//@property (nonatomic, assign) SEL function;
@property (nonatomic, assign) NSInteger itemIndex;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *title;
@end


