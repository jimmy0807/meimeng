//
//  UITextField+ExtentRange.h
//  meim
//
//  Created by 波恩公司 on 2017/11/14.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)
- (NSRange) selectedRange;
- (void) setSelectedRange:(NSRange) range;  
@end
