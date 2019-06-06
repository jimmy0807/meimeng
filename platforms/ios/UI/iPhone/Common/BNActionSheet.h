//
//  BNActionSheet.h
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNActionSheet;
@protocol BNActionSheetDelegate <NSObject>
- (void)bnActionSheet:(BNActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface BNActionSheet : UIView

- (id)initWithItems:(NSArray *)items delegate:(id<BNActionSheetDelegate>)delegate;
- (id)initWithItems:(NSArray *)items cancelTitle:(NSString *)cancelTitle delegate:(id<BNActionSheetDelegate>)delegate;
- (id)initWithTitle:(NSString *)title items:(NSArray *)items delegate:(id<BNActionSheetDelegate>)delegate;
- (id)initWithTitle:(NSString *)title items:(NSArray *)items cancelTitle:(NSString *)cancelTitle delegate:(id<BNActionSheetDelegate>)delegate;

- (void)show;
- (void)hidden;

@end
