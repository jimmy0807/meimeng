//
//  YimeiPeiyaoRightTableViewCell.h
//  meim
//
//  Created by jimmy on 2017/7/14.
//
//

#import <UIKit/UIKit.h>

@interface YimeiPeiyaoRightTableViewCell : UITableViewCell

@property(nonatomic)BOOL isAddLine;
@property(nonatomic, weak)IBOutlet UIImageView* backgroundImageView;
@property(nonatomic, strong)CDMedicalItem* item;

@end
