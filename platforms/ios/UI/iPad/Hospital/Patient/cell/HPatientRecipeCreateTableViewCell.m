//
//  HPatientRecipeCreateTableViewCell.m
//  meim
//
//  Created by 波恩公司 on 2017/9/19.
//
//

#import "HPatientRecipeCreateTableViewCell.h"

@implementation HPatientRecipeCreateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)recipeStatusButtonPressed:(id)sender
{
    self.recipeStatusButtonPressed();
}

@end
