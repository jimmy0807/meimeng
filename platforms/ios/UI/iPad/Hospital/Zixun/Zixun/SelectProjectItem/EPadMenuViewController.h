//
//  EPadMenuViewController.h
//  meim
//
//  Created by jimmy on 2018/3/20.
//

#import <UIKit/UIKit.h>

@interface EPadMenuViewController : UIViewController <UISearchBarDelegate>//<PadCategoryViewControllerDelegate, PadSubCategoryViewControllerDelegate>
- (void)didBuyItemSelected:(NSNumber *)number andName:(NSString *)name;
- (void)didUseItemSelected:(NSNumber *)number andName:(NSString *)name;

@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) NSString *fromView;
@property (nonatomic, strong) NSMutableArray *alreadySelectIDArray;
@property (nonatomic) NSNumber* zixunID;

@end
