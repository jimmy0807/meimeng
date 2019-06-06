//
//  SelectListViewTableViewCell.h
//  meim
//
//  Created by jimmy on 2017/4/21.
//
//

#import <UIKit/UIKit.h>

@interface SelectListViewTableViewCell : UITableViewCell
@property(nonatomic, weak)IBOutlet UILabel* nameLabel;
@property(nonatomic, weak)IBOutlet UILabel* rightLabel;
@property(nonatomic, weak)IBOutlet UIButton* checkIcon;
@end
