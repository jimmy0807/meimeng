//
//  YimeiAddRemarksViewController.h
//  meim
//
//  Created by jimmy on 16/12/26.
//
//

#import <UIKit/UIKit.h>

@protocol YimeiAddRemarksViewControllerDelegate <NSObject>
- (void)didYimeiAddRemarksViewControllerFinsish:(NSString*)remark;
@end

@interface YimeiAddRemarksViewController : ICCommonViewController

@property(nonatomic, strong)NSString* remark;
@property(nonatomic, weak)id<YimeiAddRemarksViewControllerDelegate> delegate;

@end
