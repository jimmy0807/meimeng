//
//  BSUserDefaultsManager.h
//  CardBag
//
//  Created by jimmy on 13-8-15.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CB_USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define UD_RememberPassword         @"UD_RememberPassword"
#define UD_UserInfoSynDate          @"UD_UserInfoSynDate"
#define UD_isAllowAcessABook        @"UD_isAllowAcessABook"
#define UD_alertSetPayPassword      @"UD_alertSetPayPassword"
#define UD_showABookAlert           @"UD_showABookAlert"
#define UD_HideAddCardProcess       @"UD_HideAddCardProcess"
#define UD_LastRequestDate          @"UD_LastRequestDate"
#define UD_isActivityCardRemoved    @"UD_isActivityCardRemoved"
#define UD_mPadPrinterRecord        @"UD_mPadPrinterRecord"
#define UD_mPadCodeScannerRecord    @"UD_mPadCodeScannerRecord"
#define UD_mPadPosMachineRecord     @"UD_mPadPosMachineRecord"

#define UD_ISPadProjectViewRemind   @"UD_ISPadProjectViewRemind"

#define UD_mPrintIP                 @"UD_mPrintIP"
#define UD_UseBigPhoto             @"UD_UseBigPhoto"

@interface BSUserDefaultsManager : NSObject

InterfaceSharedManager(BSUserDefaultsManager)

@property (nonatomic) BOOL rememberPassword;
@property (nonatomic) BOOL useBigPhoto;
@property (nonatomic) BOOL isRootViewControlHome;
@property (nonatomic) BOOL isAllowAccessABook;
@property (nonatomic) BOOL showABookAlert;
@property (nonatomic) BOOL hideAddCardProcess;
@property (nonatomic) BOOL isHaveAlertSetPayPassword;
@property (nonatomic) BOOL isActivityCardRemoved;
@property (nonatomic, strong) NSString *synDate;
@property (nonatomic, strong) NSDate *lastRandomDate;

@property (nonatomic, assign) BOOL isPadProjectViewRemind;

@property (nonatomic, strong) NSDictionary *mPadPrinterRecord;
@property (nonatomic, strong) NSDictionary *mPadCodeScannerRecord;
@property (nonatomic, strong) NSDictionary *mPadPosMachineRecord;

@property (nonatomic, strong) NSString *mPrintIP;

@end
