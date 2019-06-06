//
//  PadProjectUserSelectView.h
//  Boss
//
//  Created by XiaXianBing on 15/10/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PadProjectConstant.h"

#define kUserSelectContentHeight      181.0

typedef enum kProjectSelectUserType
{
    kProjectSelectMember,
    kProjectAddHandGrade,
    kProjectAddGiftCardVouchers
}kProjectSelectUserType;

@protocol PadProjectUserSelectViewDelegate  <NSObject>

- (void)didPadProjectUserSelectButtonClick:(kProjectSelectUserType)type;

@end

@interface PadProjectUserSelectView : UIView

@property (nonatomic, assign) id<PadProjectUserSelectViewDelegate> delegate;

- (void)reloadWithMember:(CDMember *)member;
- (void)didUserSelectViewButtonClick;

@end
