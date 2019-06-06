//
//  YimeiFumaPhotoView.h
//  meim
//
//  Created by jimmy on 2017/5/25.
//
//

#import <UIKit/UIKit.h>

@interface YimeiHuizhenPhotoView : UIView

@property(nonatomic, strong)CDHHuizhen* huizhen;
+ (void)showWithHuizhen:(CDHHuizhen*)huizhen;

@end
