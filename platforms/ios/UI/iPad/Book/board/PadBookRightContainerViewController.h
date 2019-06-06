//
//  PadBookRightContainerViewController.h
//  meim
//
//  Created by jimmy on 2017/5/24.
//
//

#import <UIKit/UIKit.h>

@interface PadBookRightContainerViewController : ICCommonViewController

@property(nonatomic, strong)CDBook* book;
@property(nonatomic, copy)void (^didConfirmButtonPressed)(CDBook* book);
@property(nonatomic, copy)void (^didCancelButtonPressed)(CDBook* book);
@property(nonatomic, copy)void (^didDeleteButtonPressed)(CDBook* book);

@end
