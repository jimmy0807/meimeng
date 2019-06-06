//
//  YimeiPosOperateLeftDetailStepTableViewCell.m
//  ds
//
//  Created by jimmy on 16/11/1.
//
//

#import "YimeiPosOperateLeftDetailStepTableViewCell.h"

@interface YimeiPosOperateLeftDetailStepTableViewCell ()
@property(nonatomic, weak)IBOutlet UIScrollView* scrollView;
@property(nonatomic, strong)NSArray* workArray;
@end

@implementation YimeiPosOperateLeftDetailStepTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)reloadAllStep
{
    self.workArray = [self.washHand.work_names componentsSeparatedByString:@","];
    
    if ( self.workArray.count > 5 )
    {
        self.scrollView.scrollEnabled = YES;
    }
    else
    {
        self.scrollView.scrollEnabled = NO;
    }
    
    [self reloadItem];
}

- (void)reloadItem
{
    __block BOOL isHighLight = TRUE;
    
    for ( UIView* v in self.scrollView.subviews )
    {
        [v removeFromSuperview];
    }
    
    [self.workArray enumerateObjectsUsingBlock:^(NSString *w, NSUInteger idx, BOOL * _Nonnull stop){
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsImageWhenDisabled = NO;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        if ( idx == 0 )
        {
            btn.frame = CGRectMake(0, 0, 84, 40);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"yimei_step_left_arrow_half"] forState:UIControlStateNormal];
        }
        else
        {
            if ( isHighLight )
            {
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                if ( idx == self.workArray.count - 1 )
                {
                    [btn setBackgroundImage:[UIImage imageNamed:@"yimei_step_right_arrow_h"] forState:UIControlStateNormal];
                }
                else
                {
                    [btn setBackgroundImage:[UIImage imageNamed:@"yimei_step_left_arrow_h"] forState:UIControlStateNormal];
                }
            }
            else
            {
                [btn setTitleColor:COLOR(188, 188, 188, 1) forState:UIControlStateNormal];
                if ( idx == self.workArray.count - 1 )
                {
                    [btn setBackgroundImage:[UIImage imageNamed:@"yimei_step_right_arrow_n"] forState:UIControlStateNormal];
                }
                else
                {
                    [btn setBackgroundImage:[UIImage imageNamed:@"yimei_step_left_arrow_n"] forState:UIControlStateNormal];
                }
            }
            
            btn.frame = CGRectMake(75 + (idx - 1)*85, 0, 95, 40);
        }
        
        if ( idx == [self.washHand.current_work_index integerValue] )
        {
            isHighLight = FALSE;
        }
        
        btn.enabled = NO;
        [btn setTitle:w forState:UIControlStateNormal];
        [self.scrollView insertSubview:btn atIndex:0];
    }];
    
    self.scrollView.contentSize = CGSizeMake(75 + (self.workArray.count - 1) * 85 + 10, 40);
}

- (void)setWashHand:(CDPosWashHand *)washHand
{
    _washHand = washHand;
    //if ( self.workArray.count == 0 )
    {
        [self reloadAllStep];
    }
}

@end
