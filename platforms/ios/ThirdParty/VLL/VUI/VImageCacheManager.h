//
//  VImageCacheManager.h
//  BetSize
//
//  Created by Vincent on 11/13/12.
//
//

#import <Foundation/Foundation.h>

@class VFileImage;

@interface VImageCacheManager : NSObject
{
    NSRecursiveLock* _locker;
}

@property(nonatomic, retain) NSMutableDictionary* imageDictionary;
+ (VImageCacheManager*)sharedManager;

- (void)addFileImage: (VFileImage*)fileImage;
- (void)removeFileImage: (VFileImage*)fileImage;
- (VFileImage*)fileImageWithFilePath: (NSString*)filePath;
@end
