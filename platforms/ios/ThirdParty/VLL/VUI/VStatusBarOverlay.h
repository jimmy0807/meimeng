//
//  VStatusBarOverlay.h
//  Spark2
//
//  Created by Vincent on 9/19/12.
//
//

#import <UIKit/UIKit.h>

#define kVStatusBarOverlayClickedNotification @"VStatusBarOverlayClickedNotification"

@class VStatusBarOverlay;

@protocol VStatusBarOverlayDelegate <NSObject>

- (BOOL)statusOverlay: (VStatusBarOverlay*)statusOverlay needShowMessage: (NSDictionary*)userInfo;

@end

@interface VStatusBarOverlay : UIWindow<UITableViewDataSource, UITableViewDelegate>
{
    UITableView* _tableView;
    NSTimer* _durationTimer;
    NSTimeInterval _duration;
    BOOL toRemove;
}

- (void)show;
- (void)hide;
- (void)addText: (NSString*)text userInfo: (NSDictionary*)userInfo duration: (NSTimeInterval)duration;

@property(nonatomic, retain) NSMutableArray* texts;
@property(nonatomic, retain) NSMutableArray* delegateStack;

- (void)pushDelegate: (id<VStatusBarOverlayDelegate>) aDelegate;
- (void)popDelegate;
+ (VStatusBarOverlay*)sharedOverlay;
@end
