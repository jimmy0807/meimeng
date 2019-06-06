//
//  GiveRemarkViewController.h
//  Boss
//
//  Created by lining on 15/10/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "Remark.h"


typedef enum kRemarkType
{
    kRemarkType_remark,
    kRemarkType_clause
}kRemarkType;

@protocol GiveRemarkDelegate <NSObject>
@optional
- (void)didSureAddRemark:(Remark *)remark type:(kRemarkType) type;
- (void)didSureEditRemark:(Remark *)remark type:(kRemarkType) type;
@end

@interface GiveRemarkViewController : ICCommonViewController

@property (assign, nonatomic) kRemarkType type;
@property (strong, nonatomic) Remark *remark;
@property (Weak, nonatomic) id<GiveRemarkDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)backBtnPressed:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextView *textView;

- (IBAction)sureBtnPressed:(UIButton *)sender;

@end
