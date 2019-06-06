//
//  ProductAttributeLineController.h
//  ds
//
//  Created by lining on 2016/11/3.
//
//

#import "ICCommonViewController.h"

@protocol ProductAttributeLineControllerDelegate <NSObject>
@optional
- (void)didSelectedAttributeLines:(NSMutableArray *)attributeLines;
@end

@interface ProductAttributeLineController : ICCommonViewController
@property (nonatomic, strong) NSMutableArray *attributeLines;
@property (nonatomic, weak)id<ProductAttributeLineControllerDelegate>delegate;
@end
