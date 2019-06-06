//
//  HPatientCreateShoushuLineViewController.h
//  meim
//
//  Created by jimmy on 2017/5/10.
//
//

#import "ICTableViewController.h"

@interface HPatientCreateShoushuLineViewController : ICTableViewController

@property(nonatomic, strong)CDHShoushuLine* shoushuLine;

@property(nonatomic, weak)IBOutlet UIImageView* itemBgImageView;
@property(nonatomic, weak)IBOutlet UITextField* itemTextField;
@property(nonatomic, weak)IBOutlet UIImageView* tagBgImageView;
@property(nonatomic, weak)IBOutlet UITextField* tagTextField;
@property(nonatomic, weak)IBOutlet UIImageView* operateDateBgImageView;
@property(nonatomic, weak)IBOutlet UITextField* operateDateTextField;
@property(nonatomic, weak)IBOutlet UIImageView* noteBgImageView;
@property(nonatomic, weak)IBOutlet UITextView* noteTextView;
@property(nonatomic, weak)IBOutlet UIImageView* reviewDayBgImageView;
@property(nonatomic, weak)IBOutlet UITextField* reviewDayTextField;
@property(nonatomic, weak)IBOutlet UIImageView* reviewDateBgImageView;
@property(nonatomic, weak)IBOutlet UITextField* reviewDateTextField;
@property(nonatomic, weak)IBOutlet UIImageView* doctorBgImageView;
@property(nonatomic, weak)IBOutlet UITextField* doctorTextField;
@property(nonatomic, strong)NSMutableArray* reviewDateArray;
@property(nonatomic, strong)NSMutableArray* removeIDArray;
@property(nonatomic, strong)NSMutableArray* addDateArray;
@property(nonatomic)BOOL isReviewDateChanged;

@property(nonatomic, copy)void (^didTagButtonPressed)(void (^selectedFinished)());
@property(nonatomic, copy)void (^didCancelFinsihed)();

@end
