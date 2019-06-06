//
//  AttributeLineHeadView.h
//  ds
//
//  Created by lining on 2016/11/3.
//
//

#import <UIKit/UIKit.h>
#import "BSAttributeLine.h"

@protocol AttributeLineHeadViewDelegate <NSObject>

@optional
- (void)didLineHeadDeleteBtnPressedAtIndexPath:(NSIndexPath *)indexPath;
- (void)didLineHeadDeleteAttributeLine:(BSAttributeLine *)attributeLine;
@end

@interface AttributeLineHeadView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<AttributeLineHeadViewDelegate>delegate;
@property (strong, nonatomic) BSAttributeLine *attributeLine;
@end
