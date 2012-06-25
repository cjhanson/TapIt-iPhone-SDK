//
//  TapItBannerAd.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapItAdDelegates.h"

@class TapItRequest;

@interface TapItBannerAdView : UIView

@property (assign, nonatomic) id<TapItBannerAdViewDelegate> delegate;
@property (assign, nonatomic) BOOL animated;
@property (readonly) BOOL isServingAds;

- (BOOL)startServingAdsForRequest:(TapItRequest *)request;
- (void)cancelAds;

- (void)repositionToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

@end
