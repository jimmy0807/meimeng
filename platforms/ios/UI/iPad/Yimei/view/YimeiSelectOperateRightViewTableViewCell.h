//
//  YimeiSelectOperateRightViewTableViewCell.h
//  meim
//
//  Created by jimmy on 2017/4/24.
//
//

#import <UIKit/UIKit.h>

@interface YimeiSelectOperateRightViewTableViewCell : UITableViewCell

@property(nonatomic, weak)IBOutlet UIImageView* topLineImageView;
@property(nonatomic, weak)IBOutlet UIImageView* bottomImageView;

@property(nonatomic, weak)IBOutlet UIButton* butotn1;
@property(nonatomic, weak)IBOutlet UIButton* butotn2;
@property(nonatomic, weak)IBOutlet UIButton* butotn3;
@property(nonatomic, weak)IBOutlet UIImageView* tag1;
@property(nonatomic, weak)IBOutlet UIImageView* tag2;
@property(nonatomic, weak)IBOutlet UIImageView* tag3;
@property(nonatomic, copy)void (^selectedAtIndex)(NSInteger index);

@end
