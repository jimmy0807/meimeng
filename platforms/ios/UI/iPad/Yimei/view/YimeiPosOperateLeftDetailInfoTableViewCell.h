//
//  YimeiPosOperateLeftDetailInfoTableViewCell.h
//  ds
//
//  Created by jimmy on 16/11/1.
//
//

#import <UIKit/UIKit.h>

@interface YimeiPosOperateLeftDetailInfoTableViewCell : UITableViewCell

- (void)showLine:(BOOL)show;

@property(nonatomic, weak)IBOutlet UILabel* leftLabel;
@property(nonatomic, weak)IBOutlet UILabel* rightLabel;

@end
