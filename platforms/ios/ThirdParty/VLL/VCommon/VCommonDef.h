//
//  VCommonDef.h
//  VLL (VinStudio Link Library)
//
//  Created by vincent on 6/21/11.
//  Copyright 2011 VinStudio. All rights reserved.
//
#ifdef __OBJC__
#define SAFE_RELEASE(p) [p release]; p = nil; 
#define SAFE_AUTORELEASE(p) [p autorelease]; p = nil; 

#ifndef LS
#define LS(string) NSLocalizedString(string, nil)
#endif

#ifndef COLOR
#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#endif

#ifndef DISTANCE
#define DISTANCE(start, end) [end distanceFromLocation:start]
#endif

#ifndef IOS7FONT
#define IOS7FONT(fontSize) [UIFont fontWithName:@"Heiti SC" size:fontSize]
#endif

#ifndef IOS7FONTBold
#define IOS7FONTBold(fontSize) [UIFont fontWithName:@"Heiti SC Medium" size:fontSize]
#endif

#ifdef DEBUG
#define NSLog(format, ...) NSLog(format, ##__VA_ARGS__)
#else
#define NSLog(format, ...)
#endif

#define VLog(format, ...) NSLog([NSString stringWithFormat: @"%@: %@", [self class], format], ## __VA_ARGS__)

#elif defined(__cplusplus)
#define SAFE_RELEASE(p) if (p) {p->release(); p = NULL;}
#endif

#ifndef DEVICE_RATIO
#define DEVICE_RATIO    ([[UIScreen mainScreen] bounds].size.width / 320.0)
#endif

#ifndef DEVICE_IS_IPHONE
#define DEVICE_IS_IPHONE    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#endif

#ifndef DEVICE_IS_IPAD
#define DEVICE_IS_IPAD    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#endif

#ifndef DEVICE_IS_IPHONE4
#define DEVICE_IS_IPHONE4   ([[UIScreen mainScreen] bounds].size.height == 480.0)
#endif

#ifndef DEVICE_IS_IPHONE5
#define DEVICE_IS_IPHONE5   ([[UIScreen mainScreen] bounds].size.height == 568)
#endif

#ifndef DEVICE_IS_IPOD
#define DEVICE_IS_IPOD    ([[[UIDevice currentDevice] model] rangeOfString:@"iPod"].location != NSNotFound)
#endif

#ifndef DEVICE_IS_NOT_IPHONE
#define DEVICE_IS_NOT_IPHONE    ([[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location == NSNotFound)
#endif

#ifndef DEGREES_TO_RADIANS
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
#endif

#ifndef IS_SDK7
#define IS_SDK7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#endif

#ifndef IS_SDK8
#define IS_SDK8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#endif

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#ifndef IOS6_MARGINS
#define IOS6_MARGINS    5.0
#endif

#ifndef IOS7_MARGINS
#define IOS7_MARGINS    16.0
#endif

#ifdef ShopAssistant

#ifndef IC_SCREEN_WIDTH
#define IC_SCREEN_WIDTH (([[[UIDevice currentDevice] systemVersion] floatValue] > 7.1)?[[UIScreen mainScreen] bounds].size.width:[[UIScreen mainScreen] bounds].size.height)
#endif
#ifndef IC_SCREEN_HEIGHT
#define IC_SCREEN_HEIGHT (([[[UIDevice currentDevice] systemVersion] floatValue] > 7.1)?[[UIScreen mainScreen] bounds].size.height:[[UIScreen mainScreen] bounds].size.width)
#endif

#else

#ifndef IC_SCREEN_WIDTH
#define IC_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#endif
#ifndef IC_SCREEN_HEIGHT
#define IC_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#endif

#endif

#ifndef NIBCT // nib convert to 
#define NIBCT(string) (DEVICE_IS_IPHONE?string:[NSString stringWithFormat:@"%@_iPad",string])
#endif

#ifndef InterfaceSharedManager
#define InterfaceSharedManager(class) \
+(class*)sharedManager;
#endif

#ifndef IMPSharedManager
#define IMPSharedManager(class) \
static class* s_sharedManager = nil;\
+ (class*)sharedManager { \
    @synchronized(s_sharedManager) { \
        if (s_sharedManager == nil) { \
            s_sharedManager = [[class alloc] init];}}\
    return s_sharedManager; }
#endif

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#ifndef Retain
#if __has_feature(objc_arc)
#define Retain strong
#else
#define Retain retain
#endif
#endif

#ifndef Strong
#define Strong Retain
#endif

#ifndef Weak
#if __has_feature(objc_arc_weak)
#define Weak weak
#elif __has_feature(objc_arc)
#define Weak unsafe_unretained
#else
#define Weak assign
#endif
#endif

#ifndef __Weak
#if __has_feature(objc_arc_weak)
#define __Weak __weak
#elif __has_feature(objc_arc)
#define __Weak __unsafe_unretained
#else
#define __Weak assign
#endif
#endif

#define WeakSelf __weak typeof(self) weakSelf = self;
