//
//  TapItAdManager.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapItAdView.h"
#import "tapItAdDelegate.h"
#import "TapItAdManagerDelegate.h"

@class TapItRequest;


@interface TapItAdManager : NSObject <TapItAdDelegate> {
    NSMutableData *connectionData;
}

@property (assign, nonatomic) id<TapItAdDelegate, TapItAdManagerDelegate> delegate;
@property (copy, nonatomic) NSDictionary *params;
@property (retain, nonatomic) NSURLConnection *currentConnection;
@property (retain, nonatomic) TapItRequest *currentRequest;

- (void)startTimerForSeconds:(NSTimeInterval)seconds;
- (void)stopTimer;

- (void)requestBannerAdWithParams:(NSDictionary *)params;
//- (void)requestInterstitialAd;
// - (void)requestOfferWall;

- (void)cancelAdRequests;

@end
