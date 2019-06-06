//
//  PadMemberSelectViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/10/20.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadProjectConstant.h"


@protocol PadMemberSelectViewControllerDelegate <NSObject>

- (void)didMemberSelectCancel;
- (void)didMemberCreateButtonClick:(BOOL)isTiyan;

@end

@interface PadMemberSelectViewController : ICCommonViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) id<PadMemberSelectViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *keyword;

- (id)initWithViewType:(kPadMemberAndCardViewType)viewType;

- (void)didTextFieldEditDone:(UITextField *)textField;

@end
