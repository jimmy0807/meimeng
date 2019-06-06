//
//  PosMachineMemberSignInViewController.h
//  ds
//
//  Created by jimmy on 16/11/15.
//
//

#import <UIKit/UIKit.h>
#import "PadMaskView.h"

@interface PosMachineMemberSignInViewController : ICCommonViewController

@property(nonatomic, strong)NSString* cardNo;;
@property(nonatomic, weak)PadMaskView* maskView;

- (void)realoadData:(BOOL)canRing;

@end
