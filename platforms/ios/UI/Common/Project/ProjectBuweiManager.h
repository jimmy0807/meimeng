//
//  ProjectBuweiManager.h
//  meim
//
//  Created by jimmy on 17/2/20.
//
//

#import <Foundation/Foundation.h>

@interface ProjectBuweiManager : NSObject

@property(nonatomic, strong)NSArray* headArray;
@property(nonatomic, strong)NSArray* bodyArray;

+ (ProjectBuweiManager*)sharedManager;

@end
