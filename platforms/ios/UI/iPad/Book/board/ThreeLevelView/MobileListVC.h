//
//  MobileListVC.h
//  meim
//
//  Created by 波恩公司 on 2017/11/6.
//


#import <UIKit/UIKit.h>
typedef void (^ReturnTextBlock)(NSString *showText,CDMember *member );

@interface MobileListVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UITableView *mobileTableView;

@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
@property(nonatomic, strong) NSMutableArray *mobileArray;
@property(nonatomic, strong) NSArray *members;

@end
