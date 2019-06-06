//
//  MemberCardChangeView.h
//  Boss
//
//  Created by lining on 16/4/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MemberCardChangedDelegate <NSObject>
- (void)didChangedCard:(CDMemberCard *)card;
@end

@interface MemberCardChangeView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *bgBtn;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) id<MemberCardChangedDelegate>delegate;
@property (strong, nonatomic) NSArray *cards;


+ (instancetype)createView;

- (IBAction)hideBtnPressed:(id)sender;
- (void)show;
- (void)showInView:(UIView *)view;
- (void)hide;

@end
