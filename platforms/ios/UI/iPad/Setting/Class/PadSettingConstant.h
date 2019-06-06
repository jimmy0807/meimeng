//
//  PadSettingConstant.h
//  Boss
//
//  Created by XiaXianBing on 15/12/1.
//  Copyright © 2015年 BORN. All rights reserved.
//

#ifndef PadSettingConstant_h
#define PadSettingConstant_h

typedef enum kPadSettingViewType
{
    kPadSettingViewDefault,
    kPadSettingViewPosMachine,
    kPadSettingViewPayAccount,
    kPadSettingViewPosAccount
}kPadSettingViewType;

typedef enum kPadSettingDetailType
{
    kPadSettingDetailDefault,
    kPadSettingDetailHandNumber,
    kPadSettingDetailFreeCombination,
    kPadSettingDetailBlueToothKeyBoard,
    kPadSettingDetailMultiKeshi,
    kPadSettingDetailPrinter,
    kPadSettingDetailCodeScanner,
    kPadSettingDetailPosMachine,
    kPadSettingDetailHandWriteBook,
    kPadSettingDetailCamera,
    kPadSettingDetailPayAccount,
    kPadSettingDetailPosAccount
}kPadSettingDetailType;

typedef enum kPadPayAccountType
{
    kPadSettingPayAccountWholeMachine,
    kPadSettingPayAccountBluetoothMachine
}kPadPayAccountType;



#define kPadNaviHeight                  75.0
#define kPadSettingLeftSideViewWidth    300.0
#define kPadSettingRightSideViewWidth   (IC_SCREEN_WIDTH - kPadSettingLeftSideViewWidth)

#endif
