//
//  HospitalMainTableViewCell.h
//  meim
//
//  Created by jimmy on 2017/4/12.
//
//

#import <UIKit/UIKit.h>

@interface HospitalMainTableViewCell : UITableViewCell
@property(nonatomic, weak)IBOutlet UILabel* titleLabel;
@property(nonatomic, weak)IBOutlet UIButton* iconImageView;
@property(nonatomic, copy)void (^addPressed)(void);

@property(nonatomic, weak)IBOutlet UIButton* rightIconButton;
@end
