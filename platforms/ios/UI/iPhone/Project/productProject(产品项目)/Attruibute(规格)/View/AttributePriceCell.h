//
//  AttributePriceCell.h
//  ds
//
//  Created by lining on 2016/11/8.
//
//

#import <UIKit/UIKit.h>
#import "BSAttributeValue.h"

@protocol AttributePriceCellDelegate <NSObject>

@optional
- (void)didEndEditAttributeValue:(BSAttributeValue *)attributeValue;

@end

@interface AttributePriceCell : UITableViewCell<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *titleBtn;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;
@property (strong, nonatomic) IBOutlet UIImageView *lineImgView;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) BSAttributeValue *attributeValue;
@property (strong, nonatomic) id<AttributePriceCellDelegate>delegate;

@end
