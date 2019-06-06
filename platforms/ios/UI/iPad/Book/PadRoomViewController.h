//
//  PadRoomViewController.h
//  meim
//
//  Created by lining on 2017/1/18.
//
//

#import "ICCommonViewController.h"

@protocol PadRoomViewControllerDelegate <NSObject>
@optional
- (void)didSelectedRoom:(CDRestaurantTable *)table;

@end

@interface PadRoomViewController : ICCommonViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id<PadRoomViewControllerDelegate> delegate;
@end
