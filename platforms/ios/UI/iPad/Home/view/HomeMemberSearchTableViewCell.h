//
//  HomeMemberSearchTableViewCell.h
//  Boss
//
//  Created by jimmy on 16/3/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeMemberSearchTableViewCellDelegate <NSObject>
- (void)willSearchContent:(NSString*)content;
@end

@interface HomeMemberSearchTableViewCell : UITableViewCell

@property(nonatomic, weak)id<HomeMemberSearchTableViewCellDelegate> delegate;
@property(nonatomic, weak)IBOutlet UITextField* searchContentTextFiled;

- (void)clear;

@end
