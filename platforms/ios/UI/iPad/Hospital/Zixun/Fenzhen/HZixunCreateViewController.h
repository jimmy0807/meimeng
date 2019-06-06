//
//  HZixunCreateViewController.h
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "ICTableViewController.h"

@interface HZixunCreateViewController : ICTableViewController

@property(nonatomic, strong)CDHZixun* zixun;
@property(nonatomic, strong)NSString* categoryName;

- (void)didSaveButtonPressed;

@end
