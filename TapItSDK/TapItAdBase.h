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
#import "TapItAdManagerDelegate.h"

@interface TapItAdBase : UIView  <TapItAdDelegate, TapItAdManagerDelegate, TapItAdBrowserControllerDelegate>

@property (assign, nonatomic) id<TapItAdDelegate> delegate;
@property (retain, nonatomic) NSString *adZone;

- (id)customParameterForKey:(NSString *)key;
- (id)setCustomParameter:(id)value forKey:(NSString *)key;
- (id)removeCustomParameterForKey:(NSString *)key;
@end
