//
//  YimeiCreateProjectItemViewController.h
//  ds
//
//  Created by jimmy on 16/11/7.
//
//

#import <UIKit/UIKit.h>
#import "PadMaskView.h"

@interface YimeiCreateProjectItemViewController : ICCommonViewController

@property (nonatomic, weak) PadMaskView *maskView;
@property (nonatomic, strong) CDProjectCategory *currentCategory;

@end
