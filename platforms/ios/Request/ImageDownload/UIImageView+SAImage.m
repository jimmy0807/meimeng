//
//  UIImageView+SAImage.m
//  ShopAssistant
//
//  Created by jimmy on 15/3/13.
//  Copyright (c) 2015年 jimmy. All rights reserved.
//

#import "UIImageView+SAImage.h"
#import "objc/runtime.h"

static char sa_image_key;

@implementation UIImageView (SAImage)
//- (void)setImage:(SAImage *)image
//{
//    objc_setAssociatedObject(self, &image_key, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (SAImage *)image
//{
//    
//}

-(void)setImageWithName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate cacheDictionary:(NSMutableDictionary*)dictionary
{
    [self setImageWithName:imageName tableName:tableName filter:filter fieldName:fieldName writeDate:writeDate placeholderImage:nil cacheDictionary:dictionary];
}

-(void)setImageWithName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate placeholderString:(NSString *)placeholder cacheDictionary:(NSMutableDictionary*)dictionary
{
    [self setImageWithName:imageName tableName:tableName filter:filter fieldName:fieldName writeDate:writeDate placeholderImage:[UIImage imageNamed:placeholder] cacheDictionary:dictionary];
}

-(void)setImageWithName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate placeholderImage:(UIImage *)placeholder cacheDictionary:(NSMutableDictionary*)dictionary
{
    [self setImageWithName:imageName tableName:tableName filter:filter fieldName:fieldName writeDate:writeDate placeholderImage:placeholder cacheDictionary:dictionary completion:nil];
}

-(void)setImageWithName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate placeholderString:(NSString *)placeholder cacheDictionary:(NSMutableDictionary*)dictionary completion:(SAImageComplete)completion
{
    [self setImageWithName:imageName tableName:tableName filter:filter fieldName:fieldName writeDate:writeDate placeholderImage:[UIImage imageNamed:placeholder] cacheDictionary:dictionary completion:completion];
}

-(void)setImageWithName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate placeholderImage:(UIImage *)placeholder cacheDictionary:(NSMutableDictionary*)dictionary completion:(SAImageComplete)completion
{
    SAImage *sa_image = objc_getAssociatedObject(self, &sa_image_key);
    [sa_image cancel];
    if (!sa_image) {
        sa_image = [[SAImage alloc] init];
    }
    
//    if ( sa_image.imageName && ![sa_image.imageName isEqualToString:imageName] )
//    {
//        [sa_image cancel];
//    }

    objc_setAssociatedObject(self, &sa_image_key, sa_image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);


    __weak UIImageView *wself = self;
    
    UIImage* image = [sa_image getImageWithName:imageName tableName:tableName filter:filter fieldName:fieldName writeDate:writeDate completion:^(UIImage* image)
    {
        if ( image )
        {
            wself.image = image;
        }
        else
        {
            wself.image = placeholder;
        }
        
        if ( image )
        {
            dictionary[imageName] = image;
        }
        
        if ( completion )
        {
            completion(image);
        }
    }];
    
    if ( image )
    {
        self.image = image;
        dictionary[imageName] = image;
        if ( completion )
        {
            completion(image);
        }
    }
    else
    {
        self.image = placeholder;
    }
}


@end
