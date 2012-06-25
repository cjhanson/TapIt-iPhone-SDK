//
//  TapItInterstitialAd.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TapItAdDelegates.h"
#import "TapItConstants.h"

@class TapItRequest;

@interface TapItInterstitialAd : NSObject

@property (assign, nonatomic) id<TapItInterstitialAdDelegate> delegate;

@property (assign) TapItInterstitialControlType controlType;
@property (assign) TapItAdType allowedAdTypes;
@property (readonly) BOOL loaded;

- (BOOL)loadInterstitialForRequest:(TapItRequest *)request;

- (void)presentFromViewController:(UIViewController *)contoller;
- (void)presentInView:(UIView *)view;

@end
