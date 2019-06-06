//
//  PadBookRightViewController.h
//  meim
//
//  Created by jimmy on 2017/5/24.
//
//

#import "ICTableViewController.h"
//2017年9月预约新增推荐人修改
#import "RecommedDetailPhoneNumberView.h"


@interface PadBookRightViewController : ICTableViewController

@property(nonatomic, strong)CDBook* book;
@property(nonatomic, weak)IBOutlet UITextView* remarkTextView;
@property(nonatomic, weak)IBOutlet UITextField* nameTextField;
@property(nonatomic, weak)IBOutlet UITextField* phoneNumberTextField;
@property(nonatomic, copy)void (^deleteButtonPressed)(void);
//2017年9月预约新增推荐人修改 推荐人手机号码
@property(nonatomic, strong) RecommedDetailPhoneNumberView *rdpV;
@property(nonatomic) BOOL infoDidChanged;
@end
