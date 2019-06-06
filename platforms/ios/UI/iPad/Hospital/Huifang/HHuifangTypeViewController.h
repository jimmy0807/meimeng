//
//  HHuifangTypeViewController.h
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import <UIKit/UIKit.h>

@interface HHuifangTypeViewController : UIViewController

@property(nonatomic, copy)void (^itemSelected)(NSInteger index);
@property(nonatomic)NSInteger currentIndex;

@end
