//
//  ScanInputCell.h
//  ds
//
//  Created by lining on 2016/10/28.
//
//

#import <UIKit/UIKit.h>


@protocol ScanInputCellDelegate <NSObject>

@optional
- (void)didScanBtnPressedAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ScanInputCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *valueTextField;
@property (strong, nonatomic) IBOutlet UIImageView *lineImgView;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<ScanInputCellDelegate>delegate;

@property (assign, nonatomic) CGFloat lineLeadingConstant;
@property (assign, nonatomic) CGFloat lineTailingConstant;

@end
