//
//  HFenzhenListTableViewCell.h
//  meim
//
//  Created by jimmy on 2017/4/14.
//
//

#import <UIKit/UIKit.h>

@interface HFenzhenListTableViewCell : UITableViewCell

@property(nonatomic, strong)CDHZixun* zixun;
@property(nonatomic, copy)void (^kaidanButtonPressed)(void);
@property(nonatomic, copy)void (^qianzaikeButtonPressed)(void);
@property(nonatomic, copy)void (^cellButtonPressed)(CDHZixun* zixun);

@property(nonatomic, weak)IBOutlet UIImageView* avatarImageView;

@end
