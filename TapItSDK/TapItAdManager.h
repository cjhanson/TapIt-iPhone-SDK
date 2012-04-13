//
//  TapItAdManager.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapItAdView.h"

@class TapItRequest;

@protocol TapItAdManagerDelegate
- (void)managerHasAdForDisplay:(TapItAdView *)theAd adType:(TapItAdType)type;
@end


@interface TapItAdManager : NSObject <UIWebViewDelegate> {
    NSMutableData *connectionData;
}

@property (assign, nonatomic) id<TapItAdManagerDelegate> delegate;
@property (copy, nonatomic) NSDictionary *params;
@property (retain, nonatomic) NSURLConnection *currentConnection;
@property (retain, nonatomic) TapItRequest *currentRequest;

- (void)requestBannerAdWithParams:(NSDictionary *)params;
//- (void)requestInterstitialAd;
// - (void)requestOfferWall;

- (void)fireAdRequest;
- (void)cancelAdRequests;

- (void)processServerResponse;

@end
