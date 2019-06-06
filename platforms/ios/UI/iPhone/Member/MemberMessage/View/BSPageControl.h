//
//  BSPageControl.h
//  Boss
//
//  Created by lining on 16/5/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSPageControl : UIView
-(id)initWithImgName:(NSString *)imgName highlightImgName:(NSString *)highlightImgName numberOfPages:(NSInteger)page;
@property(nonatomic, assign) NSInteger currentPage;
@end
