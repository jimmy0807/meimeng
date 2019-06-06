//
//  HPatientLeftShoushuTableViewCell.m
//  meim
//
//  Created by jimmy on 2017/5/9.
//
//

#import "HPatientLeftShoushuTableViewCell.h"

@interface HPatientLeftShoushuTableViewCell ()
@property(nonatomic, weak)IBOutlet UILabel* nameLabel;
@end

@implementation HPatientLeftShoushuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setShoushu:(CDHShoushu *)shoushu
{
    _shoushu = shoushu;
    
    self.nameLabel.text = shoushu.name;
}

@end
