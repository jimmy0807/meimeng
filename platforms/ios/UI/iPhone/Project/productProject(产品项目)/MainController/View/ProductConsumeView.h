//
//  ProductConsumeView.h
//  ds
//
//  Created by lining on 2016/11/9.
//
//

#import <UIKit/UIKit.h>
#import "ProductTemplateDetailViewController.h"

@interface ProductConsumeView : UIView<UITableViewDataSource,UITableViewDelegate>
+ (instancetype)createViewWithType:(ProductTmplateType)type bornCategory:(CDBornCategory *)bornCategory;
@property (strong, nonatomic) CDProjectTemplate *projectTemplate;
@property (strong, nonatomic) CDBornCategory *bornCategory;
@property (weak, nonatomic) UIViewController *viewController;

@property (nonatomic, strong) NSMutableArray *consumeArray;
- (NSMutableArray *)consumableParams;


@end
