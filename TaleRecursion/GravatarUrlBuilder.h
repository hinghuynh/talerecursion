//
//  GravatarUrlBuilder.h
//  TaleRecursion
//
//  Created by Hing Huynh on 7/28/14.
//  Copyright (c) 2014 Appcoders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GravatarUrlBuilder : NSObject

+ (NSURL *)getGravatarUrl:(NSString *)email;

@end
