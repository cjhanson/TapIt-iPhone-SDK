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

@class TapItRequest;


@interface TapItAdManager : NSObject <TapItAdDelegate> {
    NSMutableData *connectionData;
}

@property (assign, nonatomic) id<TapItAdDelegate> delegate;
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
