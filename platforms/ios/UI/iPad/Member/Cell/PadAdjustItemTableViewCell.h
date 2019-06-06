//
//  PadAdjustItemTableViewCell.h
//  meim
//
//  Created by jimmy on 17/2/8.
//
//

#import <UIKit/UIKit.h>

@interface PadAdjustItemTableViewCell : UITableViewCell

@property(nonatomic, weak)IBOutlet UIImageView* bgImageView;
@property(nonatomic, strong) CDPosProduct* cardProject;

@end
