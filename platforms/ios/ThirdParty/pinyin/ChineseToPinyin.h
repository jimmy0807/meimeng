#import <UIKit/UIKit.h>

@interface ChineseToPinyin : NSObject {
    
}

+ (NSString *)pinyinFromChiniseString:(NSString *)string;
+ (NSString *)pinyinFirstLetterString:(NSString *)string;

+ (char)sortSectionTitle:(NSString *)string;
+ (BOOL)isFirstLetterValidate:(NSString *)nameLetter;

@end