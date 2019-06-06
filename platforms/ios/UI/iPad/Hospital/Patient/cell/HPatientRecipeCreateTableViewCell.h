//
//  HPatientRecipeCreateTableViewCell.h
//  meim
//
//  Created by 波恩公司 on 2017/9/19.
//
//

#import <UIKit/UIKit.h>

@interface HPatientRecipeCreateTableViewCell : UITableViewCell

@property(nonatomic, copy)void (^recipeStatusButtonPressed)(void);
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *additionLabel;

@end
