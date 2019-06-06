//
//  HomeHeadTabView.m
//  Boss
//
//  Created by jimmy on 15/10/13.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "HomeHeadTabView.h"
#import "SpecialButton.h"
@interface HomeHeadTabView ()
@property(nonatomic, weak)IBOutlet UIButton* timeFilterButton;
@property(nonatomic, weak)IBOutlet UIButton* priceFilterButton;
@property(nonatomic, weak)IBOutlet UIButton* currentPosButton;
@property(nonatomic, weak)IBOutlet UIButton* guadanPosButton;
@property(nonatomic, weak)IBOutlet UIButton* historyPosButton;
@property(nonatomic, weak)IBOutlet UIButton* memberCardButton;
@property(nonatomic, strong)UIView* animationRect;
@property(nonatomic, weak)IBOutlet UIView* localFilterView;
@property(nonatomic, weak)IBOutlet UIView* historyFilterView;
@property(nonatomic, weak)IBOutlet UIView* historyMonthBackView;
@property(nonatomic, weak)IBOutlet UILabel* historyMonthBackViewTitle;
@property(nonatomic, weak)IBOutlet UIButton* todayFilterButton;
@property(nonatomic, weak)IBOutlet UIButton* weekFilterButton;
@property(nonatomic, weak)IBOutlet UIButton* monthFilterButton;
@property(nonatomic, weak)IBOutlet UIButton* createYimeiOrder;

@property(nonatomic, weak)IBOutlet UILabel* yimeiTitleLabel;
@property(nonatomic, weak)IBOutlet UITextField* yimeiSearchTextField;
//@property(nonatomic, weak)IBOutlet UIImageView* yimeiShowDoneIconImageView;
@property (strong, nonatomic) SpecialButton *yimeiShowDoneButton;

@end

@implementation HomeHeadTabView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.timeFilterButton.selected = YES;
    self.animationRect = [[UIView alloc] initWithFrame:CGRectMake(150, 143, 88, 3)];
    self.animationRect.backgroundColor = COLOR(82, 203, 201, 1);
    [self addSubview:self.animationRect];
#pragma mark - 9月份新修改 新赋值按钮
    //self.yimeiSearchTextField.backgroundColor = [UIColor redColor];
    self.yimeiShowDoneButton = [SpecialButton initWithTitle:@"已完成" andRect:CGRectMake(CGRectGetMaxX(self.yimeiSearchTextField.frame)+40,CGRectGetMinY(self.yimeiSearchTextField.frame)+2,64,26) andCanClick:YES andBlock:^{
        if ([self.delegate respondsToSelector:@selector(didHomeHeadTableViewShowDoneBtnPressed)]) {
            [self.delegate didHomeHeadTableViewShowDoneBtnPressed];
        }
    }];
    //NSLog(@"self.yimeiShowDoneButton: %@",self.yimeiShowDoneButton);
    [self.yimeiBackgroundView addSubview:self.yimeiShowDoneButton];
    
    //竖线
    UILabel *shuxianLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.yimeiShowDoneButton.frame)+20, CGRectGetMinY(self.yimeiShowDoneButton.frame)+5, 1, 16)];
    [self.yimeiBackgroundView addSubview:shuxianLabel];
    shuxianLabel.backgroundColor = [UIColor colorWithRed:197/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    //self.yimeiSearchTextField.backgroundColor = [UIColor redColor];
    if (![PersonalProfile currentProfile].is_post_checkout)
    {
        self.guadanPosButton.hidden = YES;
        self.historyPosButton.frame = CGRectMake(self.historyPosButton.frame.origin.x - 50, self.historyPosButton.frame.origin.y, self.historyPosButton.frame.size.width, self.historyPosButton.frame.size.height);
    }
    
    
}

- (void)reloadCreateButton
{
    if ( ![[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        self.createYimeiOrder.hidden = YES;
    }
    else
    {
        self.createYimeiOrder.hidden = NO;
    }
    if (self.isShouyintai)
    {
        self.currentPosButton.hidden = YES;
        self.historyPosButton.hidden = YES;
        self.createPosButton.hidden = YES;
        self.createYimeiOrder.hidden = YES;
        self.memberCardButton.hidden = YES;
        [self.guadanPosButton setTitle:@"收银台" forState:UIControlStateNormal];
        [self didGuadanPosButtonPressed:self.guadanPosButton];
        //self.yimeiBackgroundView.hidden = NO;
    }
}

- (IBAction)didAddButtonPressed:(UIButton*)sender
{
    CGRect r = [sender convertRect:sender.bounds toView:nil];
    [self.delegate didHomeHeadTabViewAddPosOperateButtonPressed:r.origin.y];
}

- (IBAction)didCreateYimeiNewMemberButtonPressed:(UIButton*)sender
{
    [self.delegate didCreateYimeiNewMemberButtonPressed];
}

- (IBAction)didTimeFilterButtonPressed:(id)sender
{
    self.timeFilterButton.selected = YES;
    self.priceFilterButton.selected = NO;
    self.localSortType = HomeHeadTabViewLocalSortType_Time;
    [self.delegate didHomeHeadTabViewTimeFilterButtonPressed];
}

- (IBAction)didPriceFilterButtonPressed:(id)sender
{
    self.timeFilterButton.selected = NO;
    self.priceFilterButton.selected = YES;
    self.localSortType = HomeHeadTabViewLocalSortType_Price;
    [self.delegate didHomeHeadTabViewPriceFilterButtonPressed];
}

- (IBAction)didTodayFilterButtonPressed:(id)sender
{
    self.todayFilterButton.selected = YES;
    self.weekFilterButton.selected = NO;
    self.monthFilterButton.selected = NO;
    self.historyType = HomeHeadTabViewHistoryType_Day;
    [self.delegate didHomeHeadTabViewTodayFilterButtonPressed];
}


- (IBAction)didWeekFilterButtonPressed:(id)sender
{
    self.todayFilterButton.selected = NO;
    self.weekFilterButton.selected = YES;
    self.monthFilterButton.selected = NO;
    self.historyType = HomeHeadTabViewHistoryType_Week;
    [self.delegate didHomeHeadTabViewWeekFilterButtonPressed];
}

- (IBAction)didMonthFilterButtonPressed:(id)sender
{
    self.todayFilterButton.selected = NO;
    self.weekFilterButton.selected = NO;
    self.monthFilterButton.selected = YES;
    self.historyType = HomeHeadTabViewHistoryType_Month;
    [self.delegate didHomeHeadTabViewMonthFilterButtonPressed];
}

- (IBAction)didCurrentPosButtonPressed:(UIButton*)sender
{
    if ( sender.selected )
    {
        return;
    }
    
    self.currentPosButton.selected = YES;
    self.guadanPosButton.selected = NO;
    self.historyPosButton.selected = NO;
    self.memberCardButton.selected = NO;
    
    [self moveAnimationRectToPosition:CGRectMake(150, 143, 88, 3)];
    
    self.currentHeadTab = HomeHeadTabView_Local;
    
    self.historyFilterView.hidden = YES;
    self.historyMonthBackView.hidden = YES;
    self.localFilterView.hidden = YES;
    
    [self.delegate didHomeHeadTabViewCurrentPosButtonPressed];
}

- (IBAction)didGuadanPosButtonPressed:(UIButton*)sender
{
    if ( sender.selected )
    {
        return;
    }
    self.currentPosButton.selected = NO;
    self.guadanPosButton.selected = YES;
    self.historyPosButton.selected = NO;
    self.memberCardButton.selected = NO;
    
    [self moveAnimationRectToPosition:CGRectMake(270, 143, 88, 3)];
    
    self.currentHeadTab = HomeHeadTabView_Guadan;
    
    self.historyFilterView.hidden = YES;
    self.historyMonthBackView.hidden = YES;
    self.localFilterView.hidden = YES;
    
    [self.delegate didHomeHeadTabViewGuadanPosButtonPressed];
}

- (IBAction)didHistoryPosButtonPressed:(UIButton*)sender
{
    if ( sender.selected )
    {
        return;
    }
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    if ( ![profile.isBook boolValue] )
    {
        [self.delegate didHomeHeadTabViewHistoryPosButtonPressed];
        return;
    }
    
    self.currentPosButton.selected = NO;
    self.guadanPosButton.selected = NO;
    self.historyPosButton.selected = YES;
    self.memberCardButton.selected = NO;
    
    if (![PersonalProfile currentProfile].is_post_checkout)
    {
        [self moveAnimationRectToPosition:CGRectMake(340, 143, 88, 3)];
    }
    else
    {
        [self moveAnimationRectToPosition:CGRectMake(390, 143, 88, 3)];
    }
    self.currentHeadTab = HomeHeadTabView_History;
    self.localFilterView.hidden = YES;
    
//    if ( self.historyMonthType == HomeHeadTabViewHistoryMonthType_Year )
//    {
//        self.historyFilterView.hidden = NO;
//        self.historyMonthBackView.hidden = YES;
//    }
//    else
//    {
//        self.historyFilterView.hidden = YES;
//        self.historyMonthBackView.hidden = NO;
//    }
    
    [self.delegate didHomeHeadTabViewHistoryPosButtonPressed];
}

- (IBAction)didMemberCardButtonPressed:(UIButton*)sender
{
    if ( sender.selected )
    {
        return;
    }
    
    self.currentPosButton.selected = NO;
    self.guadanPosButton.selected = NO;
    self.historyPosButton.selected = NO;
    self.memberCardButton.selected = YES;
    
    [self moveAnimationRectToPosition:CGRectMake(510, 143, 88, 3)];
    
    self.currentHeadTab = HomeHeadTabView_MemberCard;
    self.localFilterView.hidden = YES;
    
    [self.delegate didHomeHeadTabViewMemberCardButtonPressed];
}

- (IBAction)didRefreshBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didHomeHeadTableViewRefreshBtnPressed)]) {
        [self.delegate didHomeHeadTableViewRefreshBtnPressed];
    }
}

#pragma mark - 9月份新修改 注释掉 以及isDoneSelected方法内容修改
//- (IBAction)didShowDoneBtnPressed:(id)sender
//{
//    self.yimeiShowDoneIconImageView.highlighted = !self.yimeiShowDoneIconImageView.highlighted;
//    if ([self.delegate respondsToSelector:@selector(didHomeHeadTableViewShowDoneBtnPressed)]) {
//        [self.delegate didHomeHeadTableViewShowDoneBtnPressed];
//    }
//}

- (BOOL)isDoneSelected
{
    return self.yimeiShowDoneButton.isSelected;
}

- (void)moveAnimationRectToPosition:(CGRect)frame
{
    [UIView animateWithDuration:0.2 animations:^{
        self.animationRect.frame = frame;
    }];
}

- (void)showHistoryMonthBackView:(NSString*)title
{
    self.historyMonthBackView.hidden = NO;
    self.historyFilterView.hidden = YES;
    
    self.historyMonthBackViewTitle.text = title;
    
    self.historyMonthType = HomeHeadTabViewHistoryMonthType_Month;
}

- (IBAction)didHistoryMonthBackButtonPressed:(UIButton*)sender
{
    self.historyMonthBackView.hidden = YES;
    self.historyFilterView.hidden = NO;
    
    self.historyMonthType = HomeHeadTabViewHistoryMonthType_Year;
    
    [self.delegate didHomeHeadTabViewMonthBackButtonPressed];
}

- (void)setCurrentHeadTab:(HomeHeadTabViewTab)currentHeadTab
{
    _currentHeadTab = currentHeadTab;
    if ( currentHeadTab == HomeHeadTabView_Local )
    {
        [self didCurrentPosButtonPressed:self.currentPosButton];
    }
    else if ( currentHeadTab == HomeHeadTabView_History )
    {
        [self didHistoryPosButtonPressed:self.historyPosButton];
    }
    else if ( currentHeadTab == HomeHeadTabView_MemberCard )
    {
        [self didMemberCardButtonPressed:self.memberCardButton];
    }
}

- (void)doAnimationFromHistoryToLocal
{
    self.animationRect.frame = CGRectMake(310, 143, 88, 3);
    [UIView animateWithDuration:0.5 animations:^{
        self.animationRect.frame = CGRectMake(150, 143, 88, 3);
    }];
}

- (void)setYimeiTitleLabelText:(NSString*)text
{
    self.yimeiTitleLabel.text = text;
    self.yimeiBackgroundView.hidden = NO;
    CGSize minSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(300.0, 21) lineBreakMode:NSLineBreakByWordWrapping];
    self.animationRect.frame = CGRectMake(150, 146, minSize.width, 3);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.yimeiSearchTextField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegate didHomeHeadTabViewWillSearchYimeiContent:self.yimeiSearchTextField.text];
}

@end
