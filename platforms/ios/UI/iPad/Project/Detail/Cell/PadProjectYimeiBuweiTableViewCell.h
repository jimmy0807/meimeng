//
//  PadProjectYimeiBuweiTableViewCell.h
//  meim
//
//  Created by jimmy on 17/2/6.
//
//

#import <UIKit/UIKit.h>
@class PadProjectYimeiBuweiTableViewCell;

@protocol PadProjectYimeiBuweiTableViewCellDelegate <NSObject>
- (void)didPadProjectYimeiBuweiTableViewDeleteButtonPressed:(PadProjectYimeiBuweiTableViewCell*)cell;
@end

@interface PadProjectYimeiBuweiTableViewCell : UITableViewCell

@property(nonatomic, weak)IBOutlet UIImageView* bgImageView;

@property(nonatomic, weak) id<PadProjectYimeiBuweiTableViewCellDelegate> delegate;

@property(nonatomic, strong)CDYimeiBuwei* buwei;

- (void)setBuweiTitle:(NSString*)title;

@end
