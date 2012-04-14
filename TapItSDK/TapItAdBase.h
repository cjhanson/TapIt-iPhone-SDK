//
//  TapItAdBase.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapItAdDelegate.h"
#import "TapItAdBrowserController.h"

@interface TapItAdBase : UIView  <TapItAdDelegate, TapItAdBrowserControllerDelegate>

@property (assign, nonatomic) id<TapItAdDelegate> delegate;
@property (retain, nonatomic) NSString *adZone;

- (NSString *)customParameterForKey:(NSString *)key;
- (NSString *)setCustomParameterString:(NSString *)value forKey:(NSString *)key;
- (NSString *)removeCustomParameterStringForKey:(NSString *)key;
@end
