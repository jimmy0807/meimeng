//
//  YImeiSignBeforeSignTableViewCell.m
//  ds
//
//  Created by jimmy on 16/10/27.
//
//

#import "YImeiSignBeforeSignTableViewCell.h"

@interface YImeiSignBeforeSignTableViewCell()
@property(nonatomic, weak)IBOutlet UILabel* identifyLabel;
@property(nonatomic, weak)IBOutlet UILabel* mobileLabel;
@property(nonatomic, weak)IBOutlet UILabel* dateLabel;
@property(nonatomic, weak)IBOutlet UILabel* signInfoLabel;
@end

@implementation YImeiSignBeforeSignTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.drawView.delegate = self;
}

- (void)beginToDraw
{
    self.signInfoLabel.hidden = TRUE;
}

- (void)setOperate:(CDPosOperate *)operate
{
    _operate = operate;
    
    CDMember* member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:self.operate.member.memberID forKey:@"memberID"];
    self.identifyLabel.text = member.idCardNumber;
    self.mobileLabel.text = member.mobile;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.dateLabel.text = operate.operate_date;
}

- (IBAction)didClearButtonPressed:(id)sender
{
    [self.drawView clear];
    self.signInfoLabel.hidden = FALSE;
}

@end
