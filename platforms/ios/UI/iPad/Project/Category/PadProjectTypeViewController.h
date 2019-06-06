//
//  PadProjectTypeViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/10/12.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PadProjectTypeViewControllerDelegate <NSObject>

- (void)didProjectViewSelectWithBornCategory:(CDBornCategory *)bornCategory hidden:(BOOL)hidden;

@optional
- (void)didProjectViewSelectCustomPrice;

@end

@interface PadProjectTypeViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<PadProjectTypeViewControllerDelegate> delegate;
//padProdjectViewController
- (id)initWithTypes:(NSArray *)types;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
