//
//  SwitchCell.h
//  meim
//
//  Created by lining on 2016/12/14.
//
//

#import <UIKit/UIKit.h>

@protocol SwitchCellDelegate <NSObject>
@optional
- (void)switchBtnValueChanged:(BOOL)isOn;

@end

@interface SwitchCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (assign, nonatomic) BOOL isOn;
@property (weak, nonatomic) id<SwitchCellDelegate>delegate;
@end
