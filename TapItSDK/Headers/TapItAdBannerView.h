//
//  TapItBannerAd.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapItAdBannerViewDelegate.h"
#import "TapItAdBase.h"

@interface TapItAdBannerView : TapItAdBase

@property (assign, nonatomic) id<TapItAdBannerViewDelegate> delegate;
@property (assign, nonatomic) BOOL animated;

- (id)initWithFrame:(CGRect)frame andAdZone:(NSString *)theAdZone;
- (BOOL)startServingAds;

@end
