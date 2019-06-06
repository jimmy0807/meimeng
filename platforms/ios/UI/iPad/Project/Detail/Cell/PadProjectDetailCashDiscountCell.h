//
//  PadProjectDetailCashDiscountCell.h
//  meim
//
//  Created by 波恩公司 on 2017/11/8.
//

#import <UIKit/UIKit.h>

@interface PadProjectDetailCashDiscountCell : UITableViewCell

#define kPadProjectDetailItemCellHeight      148.0

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITextField *discountTextField;
@property (nonatomic, strong) UILabel *symbolLabel;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UIButton *chooseButton;
@property (nonatomic, assign) BOOL isChosen;
@property (nonatomic, assign) BOOL shouldShowMember;
@property (nonatomic, assign) float maxDiscountPoint;

- (void)reloadView;

@end

