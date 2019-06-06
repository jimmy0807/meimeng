//
//  BSCommonEditView.h
//  meim
//
//  Created by lining on 2016/12/13.
//
//

#import <UIKit/UIKit.h>

@class BSEditView;

@protocol BSEditViewDataSource <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSObject *editObject;
@property (nonatomic, strong) BSEditView *editView;
@optional
- (NSObject *)editBeforeObject;
- (NSObject *)editAfterObject;

@end

@protocol BSEditViewDelegate <NSObject>
@optional
- (void)didCancelBtnPressed;
- (void)didLeftBtnPressed;
- (void)didRightBtnPressed:(NSObject *)object;
@end

@interface BSEditView : UIView

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) CGFloat tableViewHeight;
@property (weak, nonatomic)id<BSEditViewDelegate>delegate;
@property (weak, nonatomic)id<BSEditViewDataSource>datasource;

@property (strong, nonatomic) NSObject *editObject;

+ (instancetype)createViewWithDataSource:(id<BSEditViewDataSource>)dataSource;
+ (instancetype)createViewWithDataSource:(id<BSEditViewDataSource>)dataSource addToView:(UIView *)superView;
- (void)show;
- (void)hide;

@end



