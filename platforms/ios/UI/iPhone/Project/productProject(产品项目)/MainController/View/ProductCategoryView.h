//
//  ProductCategoryView.h
//  ds
//
//  Created by lining on 2016/10/21.
//
//

#import <UIKit/UIKit.h>

@protocol ProductCategoryViewDelegate <NSObject>
@optional
- (void)didSelectedCategoryWithCategoryIds:(NSArray *)categoryIds;

@end

@interface ProductCategoryView : UIView
+ (instancetype)createView;

@property (nonatomic, strong) CDBornCategory *bornCategory;
@property (nonatomic, weak) id<ProductCategoryViewDelegate>delegate;

- (void)show;
- (void)hide;
@end
