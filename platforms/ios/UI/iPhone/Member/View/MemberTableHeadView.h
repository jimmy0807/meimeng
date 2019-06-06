//
//  MemberTableHeadView.h
//  Boss
//
//  Created by lining on 16/3/9.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MemberTableHeadViewDelegate <NSObject>
- (void)didNewContactBtnPressed;
- (void)didCallBtnPressed;
- (void)didwekaBtnPressed;
- (void)didServiceBtnPressed;
- (void)didMessageBtnPressed;
- (void)didFilterBtnPressed;
@end

@interface MemberTableHeadView : UIView

+ (instancetype)createView;

@property (nonatomic,weak) id<MemberTableHeadViewDelegate>delegate;
- (IBAction)newContactBtnPressed:(id)sender;
- (IBAction)callBtnPressed:(id)sender;
- (IBAction)wekaBtnPressed:(id)sender;
- (IBAction)serviceBtnPressed:(id)sender;
- (IBAction)messageBtnPressed:(id)sender;

- (IBAction)filterBtnPressed:(id)sender;

@end
