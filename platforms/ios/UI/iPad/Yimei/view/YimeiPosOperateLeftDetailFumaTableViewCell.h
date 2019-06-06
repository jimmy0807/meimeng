//
//  YimeiPosOperateLeftDetailFumaTableViewCell.h
//  meim
//
//  Created by jimmy on 2017/5/25.
//
//

#import <UIKit/UIKit.h>

@interface YimeiPosOperateLeftDetailFumaTableViewCell : UITableViewCell

@property(nonatomic, weak)IBOutlet UILabel* leftLabel;
@property(nonatomic, weak)IBOutlet UILabel* rightLabel;

@property(nonatomic, copy)void (^rightLabelClick)(void);

@end
