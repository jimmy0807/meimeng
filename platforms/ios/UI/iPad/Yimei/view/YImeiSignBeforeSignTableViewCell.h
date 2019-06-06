//
//  YImeiSignBeforeSignTableViewCell.h
//  ds
//
//  Created by jimmy on 16/10/27.
//
//

#import <UIKit/UIKit.h>
#import "SignDrawingNameView.h"

@interface YImeiSignBeforeSignTableViewCell : UITableViewCell<SignDrawingNameViewDelegate>

@property(nonatomic, weak)CDPosOperate* operate;
@property(nonatomic, weak)IBOutlet SignDrawingNameView* drawView;

@end
