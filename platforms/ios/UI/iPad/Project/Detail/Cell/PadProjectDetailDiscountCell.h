//
//  PadProjectDetailDiscountCell.h
//  meim
//
//  Created by 波恩公司 on 2017/11/8.
//

#import <UIKit/UIKit.h>

@interface PadProjectDetailDiscountCell : UITableViewCell

#define kPadProjectDetailItemCellHeight      148.0

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITextField *discountTextField;
@property (nonatomic, strong) UILabel *symbolLabel;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, assign) float maxDiscountPoint;
@property (nonatomic, assign) float pointsChangeMoney;

- (void)reloadView;

@end
