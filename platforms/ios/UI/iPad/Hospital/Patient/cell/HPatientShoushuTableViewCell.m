//
//  HPatientShoushuTableViewCell.m
//  meim
//
//  Created by jimmy on 2017/5/10.
//
//

#import "HPatientShoushuTableViewCell.h"
#import "UILabel+ColorFont.h"
#import "NSDate+Formatter.h"

@interface HPatientShoushuTableViewCell ()
@property(nonatomic, weak)IBOutlet UILabel* titleLabel;
@property(nonatomic, weak)IBOutlet UILabel* itemLabel;
@property(nonatomic, weak)IBOutlet UILabel* timeLabel;
@property(nonatomic, weak)IBOutlet UILabel* stateLabel;
@property(nonatomic, weak)IBOutlet UILabel* infoLabel;
@end

@implementation HPatientShoushuTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setShoushu:(CDHShoushuLine *)shoushu
{
    _shoushu = shoushu;
    
    if ( [shoushu.state isEqualToString:@"cancel"] )
    {
        [self.titleLabel setAttributeString:[NSString stringWithFormat:@"第%@次手术 (已取消)",shoushu.sortIndex] colorString:@"(已取消)" color:COLOR(255, 72, 72, 1) font:nil];
    }
    else
    {
        self.titleLabel.text = [NSString stringWithFormat:@"第%@次手术",shoushu.sortIndex];
    }
    
    self.itemLabel.text = shoushu.name;
    self.timeLabel.text = shoushu.operate_date;
    NSString *dateString = [[NSString alloc] init];
    NSArray *elementArray = [shoushu.review_date componentsSeparatedByString:@","];
    for (int i = 0; i < elementArray.count; i++) {
        if (i > 0)
        {
            dateString = [NSString stringWithFormat:@"%@\n",dateString];
        }
        NSArray *datePartArray = [elementArray[i] componentsSeparatedByString:@"@"];
        if (datePartArray.count > 1){
            NSString *datePartString = datePartArray[1];
            dateString = [NSString stringWithFormat:@"%@%@",dateString,[[NSDate dateFromString:datePartString] dateStringWithFormatter:@"yyyy-MM-dd HH:mm"]];
            //[dateString stringByAppendingString:[[NSDate dateFromString:datePartString] dateStringWithFormatter:@"yyyy-MM-dd HH:mm"]];
        }
    }
//    self.stateLabel.frame = CGRectMake(90, self.stateLabel.frame.origin.y, self.stateLabel.frame.size.width, [shoushu.review_date componentsSeparatedByString:@","].count * 17);
    self.stateLabel.text = [NSString stringWithFormat:@"%@",dateString];
    self.stateLabel.numberOfLines = [shoushu.review_date componentsSeparatedByString:@","].count;
    if ( [shoushu.note isEqualToString:@"0"] )
    {
        self.infoLabel.text = @"无手术情况";
    }
    else
    {
        self.infoLabel.text = shoushu.note;
    }
}

@end
