//
//  DecompressHandler.h
//  Mate
//
//  Created by Petar Atanasov on 9/15/16.
//  Copyright © 2016 Wacom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DecompressHandler : NSObject

+(uint32_t) crc32ValueForData:(NSData*) data;

int decompressAlgorithm(char const *filename, char const *filename_out);

@end
