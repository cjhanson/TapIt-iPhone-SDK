//
//  TapItAdManagerDelegate.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TapItConstants.h"

@class TapItAdView;

@protocol TapItAdManagerDelegate <NSObject>
- (void)managerHasAdForDisplay:(TapItAdView *)theAd adType:(TapItAdType)type;
@end
