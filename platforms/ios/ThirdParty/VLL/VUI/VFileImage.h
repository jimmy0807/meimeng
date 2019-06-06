//
//  VFileImage.h
//  BetSize
//
//  Created by Vincent on 11/13/12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VFileImage : UIImage
{
    BOOL needDelete;
}

@property(nonatomic, copy)NSString* filePath;
+ (VFileImage *)imageWithContentsOfFile:(NSString *)path;
+ (void)removeFileImage:(NSString *)path;
@end
