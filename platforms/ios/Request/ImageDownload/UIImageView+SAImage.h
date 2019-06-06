//
//  UIImageView+SAImage.h
//  ShopAssistant
//
//  Created by jimmy on 15/3/13.
//  Copyright (c) 2015年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAImage.h"

@interface UIImageView (SAImage)
//@property (nonatomic, strong) SAImage *image;

-(void)setImageWithName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate cacheDictionary:(NSMutableDictionary*)dictionary;

-(void)setImageWithName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate placeholderString:(NSString *)placeholder cacheDictionary:(NSMutableDictionary*)dictionary;

-(void)setImageWithName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate placeholderImage:(UIImage *)placeholder cacheDictionary:(NSMutableDictionary*)dictionary;

-(void)setImageWithName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate placeholderString:(NSString *)placeholder cacheDictionary:(NSMutableDictionary*)dictionary completion:(SAImageComplete)completion;

-(void)setImageWithName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate placeholderImage:(UIImage *)placeholder cacheDictionary:(NSMutableDictionary*)dictionary completion:(SAImageComplete)completion;

@end
