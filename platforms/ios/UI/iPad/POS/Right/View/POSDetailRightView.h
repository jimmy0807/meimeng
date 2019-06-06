//
//  HomeDetailRightView.h
//  Boss
//
//  Created by lining on 15/10/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol POSDetailRightViewDelegate <NSObject>
@optional
-(void)didSelectedAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface POSDetailRightView : UIView<UITableViewDataSource,UITableViewDelegate>

+ (instancetype)createView;
@property (strong, nonatomic) CDPosOperate *operate;
@property (Weak, nonatomic) id<POSDetailRightViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void) reloadRightView;

@end
