//
//  HPatientElectonicRecipeViewController.h
//  meim
//
//  Created by 波恩公司 on 2017/9/19.
//
//

#import <UIKit/UIKit.h>
#import "HPatientCreateRecipeViewController.h"

@interface HPatientElectonicRecipeViewController : UIViewController

@property(nonatomic, strong)CDMember* member;
@property(nonatomic, strong)HPatientCreateRecipeViewController* createVC;

- (void)popNavi;
- (void)didCreateRecipeButtonPressed;
- (void)didSaveRecipeButtonPressed;
- (void)didBackButtonPressed;

@end
