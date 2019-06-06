//
//  ProductPicCell.h
//  ds
//
//  Created by lining on 2016/10/28.
//
//

#import <UIKit/UIKit.h>

@protocol ProductPicCellDelegate <NSObject>
@optional
- (void)didSelectedPicBtnPressed;
@end


@interface ProductPicCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *picImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;

@property(weak, nonatomic) id<ProductPicCellDelegate>delegate;

@end
