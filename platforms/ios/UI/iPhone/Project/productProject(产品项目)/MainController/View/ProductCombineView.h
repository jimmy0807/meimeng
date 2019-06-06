//
//  ProductCombineOrConsumeView.h
//  ds
//  组合或消耗品View
//  Created by lining on 2016/10/31.
//
//

#import <UIKit/UIKit.h>
#import "ProductTemplateDetailViewController.h"

@interface ProductCombineView : UIView

+ (instancetype)createViewWithType:(ProductTmplateType)type bornCategory:(CDBornCategory *)bornCategory;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CDProjectTemplate *projectTemplate;
@property (strong, nonatomic) CDBornCategory *bornCategory;
@property (weak, nonatomic) UIViewController *viewController;

@property (nonatomic, strong) NSMutableArray *subItems;
- (NSArray *)subItemsParams;
@end
