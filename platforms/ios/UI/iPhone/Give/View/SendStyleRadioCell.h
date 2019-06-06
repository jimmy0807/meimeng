//
//  SendStyleRadioCell.h
//  Boss
//
//  Created by lining on 16/9/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RadioCellDelegate <NSObject>
@optional
- (void)isDirectedSend:(BOOL)isDirectSend;


@end

@interface SendStyleRadioCell : UITableViewCell

@property (nonatomic, weak) id<RadioCellDelegate>delegate;
@property (nonatomic, assign) BOOL isDirectSend;

@end
