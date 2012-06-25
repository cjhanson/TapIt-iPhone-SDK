//
//  TapItAdManagerDelegate.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TapItPrivateConstants.h"

@class TapItAdView, TapItRequest;

@protocol TapItAdManagerDelegate <NSObject>
@required
- (void)willLoadAdWithRequest:(TapItRequest *)request;
- (void)didLoadAdView:(TapItAdView *)adView;
- (void)adView:(TapItAdView *)adView didFailToReceiveAdWithError:(NSError*)error;
- (BOOL)adActionShouldBegin:(NSURL *)actionUrl willLeaveApplication:(BOOL)willLeave;
- (void)adViewActionDidFinish:(TapItAdView *)adView;

@optional
- (void)didReceiveResponse:(TapItAdView *)adView;

- (void)timerElapsed;
@end
