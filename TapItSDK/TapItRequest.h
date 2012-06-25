//
//  TapItRequest.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TapItRequest : NSObject

+ (TapItRequest *)requestWithAdZone:(NSString *)zone;
+ (TapItRequest *)requestWithAdZone:(NSString *)zone andCustomParameters:(NSDictionary *)theParams;

- (id)customParameterForKey:(NSString *)key;
- (id)setCustomParameter:(id)value forKey:(NSString *)key;
- (id)removeCustomParameterForKey:(NSString *)key;

@end
