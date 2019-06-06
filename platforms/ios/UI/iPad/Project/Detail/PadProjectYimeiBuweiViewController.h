//
//  PadProjectYimeiBuweiViewController.h
//  meim
//
//  Created by jimmy on 17/2/6.
//
//

#import <UIKit/UIKit.h>

@protocol PadProjectYimeiBuweiViewControllerDelegate <NSObject>
- (void)didBuweiEditFinished:(CDYimeiBuwei*)buwei;
@end

@interface PadProjectYimeiBuweiViewController : ICCommonViewController

@property(nonatomic, strong)CDYimeiBuwei* buwei;
@property(nonatomic, weak)id<PadProjectYimeiBuweiViewControllerDelegate> delegate;
@property(nonatomic)NSInteger totalCount;
@end
