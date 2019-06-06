//
//  moreSetupCell.h
//  Boss
//
//  Created by jiangfei on 16/6/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class moreSetupModel;
@protocol moreSetupCellDelegate <NSObject>

@optional
//编辑textField
-(void)moreSetupCellDelegateWith:(NSString*)text andModel:(moreSetupModel*)updateModel;
-(void)moreSetupCellEditImageBtnSeletedStatus:(BOOL)seleted andModel:(moreSetupModel*)updateModel;
@end
@interface moreSetupCell : UITableViewCell
/** setupModel*/
@property (nonatomic,strong)moreSetupModel *setUpModel;
/** delegate*/
@property (nonatomic,weak)id<moreSetupCellDelegate>delegate;
@end
