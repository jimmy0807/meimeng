//
//  PadProjectConstant.h
//  Boss
//
//  Created by XiaXianBing on 15/10/26.
//  Copyright © 2015年 BORN. All rights reserved.
//

#ifndef PadProjectConstant_h
#define PadProjectConstant_h

typedef enum kPadProjectPosOperateType
{
    kPadProjectPosOperateEdit,
    kPadProjectPosOperateCreate,
    kPadProjectPosOperateHistory
}kPadProjectPosOperateType;

typedef enum kPadProjectResultType
{
    kPadProjectResultDefault,
    kPadProjectResultSearch
}kPadProjectResultType;

typedef enum kPadMemberAndCardViewType
{
    kPadMemberAndCardDefault,
    kPadMemberAndCardSelect,
    kPadMemberAndCardBook
}kPadMemberAndCardViewType;



#define kPadNaviHeight                  75.0
#define kPadInputFieldWidth             540.0
#define kPadConfirmButtonHeight         60.0
#define kPadProjectSideViewWidth        300.0
#define kPadCardOperateWidth            90.0
#define kPadCardIntervalWidth           16.0
#define kPadMemberAndCardInfoWidth      (IC_SCREEN_WIDTH - kPadCardOperateWidth - kPadProjectSideViewWidth - 2 * kPadCardIntervalWidth)
#define kPadCardOperateButtonWidth      92.0
#define kPadCardOperateButtonHeight     64.0
#define kPadProjectSideCellWidth        300.0
#define kPadProjectSideCellHeight       88.0
#define kPadUsingItemCellHeight         60.0
#define kPadProjectTypeViewHeight       480.0
#define kPadProjectCategoryCellWidth    320.0
#define kPadProjectCategoryCellHeight   44.0
#define kPadCustomItemCellHeight        56.0
#define kPadMemberAvatarWidth           90.0
#define kPadMemberAvatarHeight          90.0
#define kPadProjectBankPayMaxAmount     30000.0

#endif
