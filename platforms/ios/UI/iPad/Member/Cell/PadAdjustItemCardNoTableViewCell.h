//
//  PadAdjustItemCardNoTableViewCell.h
//  meim
//
//  Created by jimmy on 17/2/8.
//
//

#import <UIKit/UIKit.h>

@interface PadAdjustItemCardNoTableViewCell : UITableViewCell
@property(nonatomic, weak)IBOutlet UITextField* cardNoTextField;
@property(nonatomic, weak)IBOutlet UITextField* amountTextField;
@property(nonatomic, weak)IBOutlet UITextField* pointTextField;
@property(nonatomic, strong)CDMemberCard* card;
@end
