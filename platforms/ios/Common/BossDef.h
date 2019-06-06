//
//  BossDef.h
//  Boss
//
//  Created by XiaXianBing on 15/3/30.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#ifndef BOSS_DEF_H
#define BOSS_DEF_H

#define CB_LOADING_HEADER   1
#define CB_LOADING_FOOTER   1<<1

#ifndef RandomKeyServerRandom
#define RandomKeyServerRandom       @"RandomKeyServerRandom"
#endif

#ifndef LS
#define LS(string) NSLocalizedString(string, nil)
#endif

#ifndef GestureUnlockTimes
#define GestureUnlockTimes(string)     [NSString stringWithFormat:@"GestureUnlockTimes_%@", string]
#endif

#ifndef GestureUnlockPassword
#define GestureUnlockPassword(string)   [NSString stringWithFormat:@"GestureUnlockPassword_%@", string]
#endif

#ifndef kPayPassword
#define kPayPassword(string) [NSString stringWithFormat:@"kPayPassword_%@",string]
#endif

#ifndef WrapIdentifier
#define WrapIdentifier  @"{[-!-]}"
#endif


#define AppThemeColor  [UIColor colorWithRed:29/255.0 green:130/255.0 blue:210/255.0 alpha:1]


#endif

