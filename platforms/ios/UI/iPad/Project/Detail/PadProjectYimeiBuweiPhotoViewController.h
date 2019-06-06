//
//  PadProjectYimeiBuweiPhotoViewController.h
//  meim
//
//  Created by jimmy on 17/2/20.
//
//

#import <UIKit/UIKit.h>

@protocol PadProjectYimeiBuweiPhotoViewControllerDelegate <NSObject>

@end

@interface PadProjectYimeiBuweiPhotoViewController : ICCommonViewController

@property(nonatomic, strong)CDPosProduct* product;
@property(nonatomic, strong)CDCurrentUseItem* item;

@property(nonatomic, weak)id<PadProjectYimeiBuweiPhotoViewControllerDelegate> delegate;

@end
