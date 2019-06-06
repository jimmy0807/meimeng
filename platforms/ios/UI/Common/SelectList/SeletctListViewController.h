//
//  SeletctListViewController.h
//  meim
//
//  Created by jimmy on 2017/4/21.
//
//

#import <UIKit/UIKit.h>

@interface SeletctListViewController : UIViewController

@property(nonatomic, copy)NSString* (^nameAtIndex)(NSInteger index);
@property(nonatomic, copy)NSString* (^rightInfoAtIndex)(NSInteger index);
@property(nonatomic, copy)void (^selectAtIndex)(NSInteger index);
@property(nonatomic, copy)void (^multiSelectFinish)(NSOrderedSet* set);
@property(nonatomic, copy)BOOL (^isSelected)(NSInteger);
@property(nonatomic, copy)NSInteger (^countOfTheList)(void);

- (void)showWithAnimation;
- (void)close;

@property(nonatomic)BOOL noSort;
@property(nonatomic)NSMutableOrderedSet* selectIndexSet;
@property(nonatomic)BOOL multiSelect;

@end
