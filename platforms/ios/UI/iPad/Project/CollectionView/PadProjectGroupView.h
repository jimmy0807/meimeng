//
//  PadProjectGroupView.h
//  meim
//
//  Created by jimmy on 2017/5/16.
//
//

#import <UIKit/UIKit.h>

@interface PadProjectGroupView : UIView

- (void)show;

@property(nonatomic, strong)NSArray* itemArray;

@property(nonatomic, copy)void (^selectItem)(CDProjectItem* item);

@end
