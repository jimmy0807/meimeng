//
//  PadBookTechnicianView.h
//  Boss
//
//  Created by jimmy on 15/11/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PadBookTechnicianViewDelegate <NSObject>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView padBookTechnicianView:(UIView*)PadBookTechnicianView;
@end

@interface PadBookTechnicianView : UIView

- (void)initWithTechnicianArray:(NSArray*)technicianArray;
- (void)initWithTableArray:(NSArray *)tableArray;

- (void)reloadWithTableArray:(NSArray *)tableArray;
- (void)realoadTechnicianName:(NSString*)time;

@property(nonatomic, weak)IBOutlet UIScrollView* scrollView;
@property(nonatomic, weak)id<PadBookTechnicianViewDelegate> delegate;

@end
