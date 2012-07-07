//
//  TapItInterstitialAd.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 Responsible for loading up the appropriate type of interstitial controller...
 */

#import "TapItInterstitialAd.h"
#import "TapItAdManager.h"
#import "TapItBannerAdView.h"
#import "TapItInterstitialAdViewController.h"
#import "TapItActionSheetAdViewController.h"
#import "TapItLightboxAdViewController.h"
#import "TapItRequest.h"

@interface TapItInterstitialAd() <TapItAdManagerDelegate> {
    BOOL isLoaded;
    BOOL prevStatusBarHiddenState;
}
@property (retain, nonatomic) TapItRequest *adRequest;
@property (retain, nonatomic) TapItAdView *adView;
@property (retain, nonatomic) TapItAdManager *adManager;
@property (retain, nonatomic) TapItBannerAdView *bannerView;
@property (retain, nonatomic) UIView *presentingView;

@end

@implementation TapItInterstitialAd

@synthesize delegate, adRequest, adView, adManager, allowedAdTypes, controlType, bannerView, presentingView, animated;

- (id)init {
    self = [super init];
    if (self) {
        self.adManager = [[[TapItAdManager alloc] init] autorelease];
        self.adManager.delegate = self;
        self.controlType = TapItActionSheetControlType;
        self.allowedAdTypes = TapItFullscreenAdType|TapItOfferWallType|TapItVideoAdType;
        self.animated = YES;
        isLoaded = NO;
    }
    return self;
}

- (BOOL)loaded {
    return isLoaded;
}

- (BOOL)loadInterstitialForRequest:(TapItRequest *)request {
    self.adRequest = request;
    [self.adRequest setCustomParameter:@"2" forKey:@"adtype"];
    [self.adManager fireAdRequest:self.adRequest];
    return YES;
}

- (void)presentFromViewController:(UIViewController *)controller {
    UIApplication *app = [UIApplication sharedApplication];
    prevStatusBarHiddenState = app.statusBarHidden;
    [app setStatusBarHidden:YES];
    TapItInterstitialAdViewController *adController;
    if (self.controlType == TapItActionSheetControlType) {
        adController = (TapItInterstitialAdViewController *)[[TapItActionSheetAdViewController alloc] init];
    }
    else {
        adController = (TapItInterstitialAdViewController *)[[TapItLightboxAdViewController alloc] init];
    }
    adController.adView = self.adView;
    adController.animated = self.animated;
//    adController.tapitDelegate = self.delegate;
    adController.tapitDelegate = self;
    self.adView.delegate = adController;
    
    [controller presentModalViewController:adController animated:YES];
    [adController release];
}

//- (void)presentInView:(UIView *)view {
//    //TODO: this code needs to be re-done
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
//    bgView.backgroundColor = [UIColor blackColor];
//    [bgView addSubview:self.adView];
//    [self.adView setCenter:bgView.center];
//    [view addSubview:bgView];
//    
//    self.presentingView = view;
//    
//    switch (self.controlType) {
//        case TapItLightboxControlType:
//            [self addLightboxControlsToView:bgView];
//            break;
//        case TapItActionSheetControlType:
//            [self addActionSheetControlsToView:bgView];
//        default:
//            break;
//    }
//    [bgView release];
//}
//
//- (void)addActionSheetControlsToView:(UIView *)view {
//    //TODO: implement me
//}
//                      
//- (void)addLightboxControlsToView:(UIView *)view {
//    //TODO: implement me
//}

#pragma mark -
#pragma mark TapItAdManagerDelegate methods

- (void)willLoadAdWithRequest:(TapItRequest *)request {
    if ([self.delegate respondsToSelector:@selector(tapitInterstitialAdWillLoad:)]) {
        [self.delegate tapitInterstitialAdWillLoad:self];
    }
}

- (void)didReceiveResponse:(TapItAdView *)adView {
}

- (void)didLoadAdView:(TapItAdView *)theAdView {
    self.adView = theAdView;
    isLoaded = YES;
    if ([self.delegate respondsToSelector:@selector(tapitInterstitialAdDidLoad:)]) {
        [self.delegate tapitInterstitialAdDidLoad:self];
    }
}

- (void)adView:(TapItAdView *)adView didFailToReceiveAdWithError:(NSError*)error {
    [self tapitInterstitialAd:self didFailWithError:error];
}

- (BOOL)adActionShouldBegin:(NSURL *)actionUrl willLeaveApplication:(BOOL)willLeave {
    BOOL shouldLoad = YES;
    if ([self.delegate respondsToSelector:@selector(tapitInterstitialAdActionShouldBegin:willLeaveApplication:)]) {
        shouldLoad = [self.delegate tapitInterstitialAdActionShouldBegin:self willLeaveApplication:willLeave];
    }
    
    if (shouldLoad && self.presentingView) {
        //TODO: move this code into a [adView expandToFrame:] call?
        [UIView animateWithDuration:0.5 animations:^{
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.adView cache:YES];
            self.adView.frame = self.presentingView.frame;
        }
        completion:^(BOOL finished){}
        ];
        
        
    }
    return shouldLoad;
}

- (void)tapitInterstitialAdDidUnload:(TapItInterstitialAd *)interstitialAd {
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:prevStatusBarHiddenState];

    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(tapitInterstitialAdDidUnload:)]) {
            [self.delegate tapitInterstitialAdDidUnload:self];
        }
    }
}

- (void)adViewActionDidFinish:(TapItAdView *)adView {
    // This method should always be overridden by child class
}








- (void)tapitInterstitialAd:(TapItInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    isLoaded = NO;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(tapitInterstitialAd:didFailWithError:)]) {
            [self.delegate tapitInterstitialAd:self didFailWithError:error];
        }
    }
}

//- (void)tapitInterstitialAdWillLoad:(TapItInterstitialAd *)interstitialAd {
//    //TODO do we need this?  dev will know when an interstitial is loaded because they fired a load event!
//    if (self.delegate) {
//        if ([self.delegate respondsToSelector:@selector(tapitInterstitialAdWillLoad:)]) {
//            [self.delegate tapitInterstitialAdWillLoad:self];
//        }
//    }
//}
//
//- (void)tapitInterstitialAdDidLoad:(TapItInterstitialAd *)interstitialAd {
//    //TODO not needed, covered by - (void)didLoadAdView:(TapItAdView *)theAdView above...
//    if (self.delegate) {
//        if ([self.delegate respondsToSelector:@selector(tapitInterstitialAdDidLoad:)]) {
//            [self.delegate tapitInterstitialAdDidLoad:self];
//        }
//    }
//}
//
- (BOOL)tapitInterstitialAdActionShouldBegin:(TapItInterstitialAd *)interstitialAd willLeaveApplication:(BOOL)willLeave {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(tapitInterstitialAdActionShouldBegin:willLeaveApplication:)]) {
            return [self.delegate tapitInterstitialAdActionShouldBegin:self willLeaveApplication:willLeave];
        }
    }
    return YES;
}

- (void)tapitInterstitialAdActionDidFinish:(TapItInterstitialAd *)interstitialAd {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(tapitInterstitialAdActionDidFinish:)]) {
            [self.delegate tapitInterstitialAdActionDidFinish:self];
        }
    }
}












- (void)timerElapsed {
    // This method should be overridden by child class
}

- (UIViewController *)getDelegate {
    return (UIViewController *)self.delegate;
}

- (void)dealloc {
    self.adRequest = nil;
    self.adView = nil;
    self.adManager = nil;
    self.bannerView = nil;
    self.presentingView = nil;
    
    [super dealloc];
}

@end
