//
//  ZixunMemberSelectViewController.h
//  meim
//
//  Created by 波恩公司 on 2017/11/2.
//

#import "ICCommonViewController.h"
#import "PadProjectConstant.h"


@protocol ZixunMemberSelectViewControllerDelegate <NSObject>

- (void)didMemberSelectCancel;
//- (void)didMemberCreateButtonClick:(BOOL)isTiyan;

@end

@interface ZixunMemberSelectViewController : ICCommonViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) id<ZixunMemberSelectViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) IBOutlet UIImageView *bgView;

- (id)initWithViewType:(kPadMemberAndCardViewType)viewType;

- (void)didTextFieldEditDone:(UITextField *)textField;

@end
