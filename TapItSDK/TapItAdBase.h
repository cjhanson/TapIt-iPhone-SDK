//
//  TapItAdBase.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapItAdManager.h"

@interface TapItAdBase : UIView  <TapItAdManagerDelegate>

@property (retain, nonatomic) NSString *adZone;

- (NSString *)customParameterForKey:(NSString *)key;
- (NSString *)setCustomParameterString:(NSString *)value forKey:(NSString *)key;
- (NSString *)removeCustomParameterStringForKey:(NSString *)key;
@end
