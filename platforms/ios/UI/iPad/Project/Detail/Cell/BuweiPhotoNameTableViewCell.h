//
//  BuweiPhotoNameTableViewCell.h
//  meim
//
//  Created by jimmy on 17/2/20.
//
//

#import <UIKit/UIKit.h>
@class BuweiPhotoNameTableViewCell;

@protocol BuweiPhotoNameTableViewCellDelegate <NSObject>
- (void)didCountChanged:(BuweiPhotoNameTableViewCell*)cell count:(CGFloat)count;
@end

@interface BuweiPhotoNameTableViewCell : UITableViewCell

@property(nonatomic, strong)CDYimeiBuwei* buwei;
@property(nonatomic, weak)id<BuweiPhotoNameTableViewCellDelegate> delegate;

@end
