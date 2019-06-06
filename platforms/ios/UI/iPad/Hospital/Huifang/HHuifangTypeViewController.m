//
//  HHuifangTypeViewController.m
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import "HHuifangTypeViewController.h"

@interface HHuifangTypeViewController ()
@property(nonatomic, strong)IBOutletCollection(UILabel) NSArray* titleLabels;
@end

@implementation HHuifangTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel* label = _titleLabels[self.currentIndex];
    label.textColor = COLOR(94, 210, 211, 1);
}

- (IBAction)didItemSelect:(UIButton*)sender
{
    NSInteger tag = sender.tag;
    self.itemSelected(tag);
}

@end
