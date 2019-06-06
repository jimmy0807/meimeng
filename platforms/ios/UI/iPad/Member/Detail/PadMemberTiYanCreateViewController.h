//
//  PadMemberTiYanCreateViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/10/28.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "BNActionSheet.h"
#import "PadMemberAndCardViewController.h"

@interface PadMemberTiYanCreateViewController : ICCommonViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, BNActionSheetDelegate, UITextFieldDelegate>

@property (nonatomic, strong) PadMaskView *maskView;
@property (nonatomic, strong) PadMemberAndCardViewController *parent;

- (id)initWithMember:(CDMember*)member;

@end
