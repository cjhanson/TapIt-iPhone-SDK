//
//  TapItInterstitialAd.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TapItInterstitialAd.h"
#import "TapItAdManager.h"
#import "TapItBannerAdView.h"
#import "TapItFullScreenAdViewController.h"
#import "TapItRequest.h"

@interface TapItInterstitialAd() <TapItAdManagerDelegate> {
    BOOL isLoaded;
}
@property (retain, nonatomic) TapItRequest *adRequest;
@property (retain, nonatomic) TapItAdView *adView;
@property (retain, nonatomic) TapItAdManager *adManager;
@property (retain, nonatomic) TapItBannerAdView *bannerView;
@property (retain, nonatomic) UIView *presentingView;

@end

@implementation TapItInterstitialAd

@synthesize delegate, adRequest, adView, adManager, allowedAdTypes, controlType, bannerView, presentingView;

- (id)init {
    self = [super init];
    if (self) {
        self.adManager = [[[TapItAdManager alloc] init] autorelease];
        self.adManager.delegate = self;
        self.controlType = TapItLightboxControlType;
        self.allowedAdTypes = TapItFullscreenAdType|TapItOfferWallType|TapItVideoAdType;
        
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

- (void)presentFromViewController:(UIViewController *)controller { // withControlType: actionSheet/lightbox
    TapItFullScreenAdViewController *adController = [[TapItFullScreenAdViewController alloc] init];
    adController.adView = self.adView;
    [controller presentModalViewController:adController animated:YES];
    [adController release];
}

- (void)presentInView:(UIView *)view {
    //TODO: this code needs to be re-done
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    bgView.backgroundColor = [UIColor blackColor];
    [bgView addSubview:self.adView];
    [self.adView setCenter:bgView.center];
    [view addSubview:bgView];
    
    self.presentingView = view;
    
    switch (self.controlType) {
        case TapItLightboxControlType:
            [self addLightboxControlsToView:bgView];
            break;
        case TapItActionSheetControlType:
            [self addActionSheetControlsToView:bgView];
        default:
            break;
    }
    [bgView release];
}

- (void)addActionSheetControlsToView:(UIView *)view {
    //TODO: implement me
}
                      
- (void)addLightboxControlsToView:(UIView *)view {
    //TODO: implement me
}

#pragma mark -
#pragma mark TapItAdManagerDelegate methods

- (void)willLoadAdWithRequest:(TapItRequest *)request {
    if ([delegate respondsToSelector:@selector(tapitInterstitialAdWillLoad:)]) {
        [delegate tapitInterstitialAdWillLoad:self];
    }
}

- (void)didReceiveResponse:(TapItAdView *)adView {
    NSLog(@"didReceiveResponse");
}

- (void)didLoadAdView:(TapItAdView *)theAdView {
    self.adView = theAdView;
    isLoaded = YES;
    if ([delegate respondsToSelector:@selector(tapitInterstitialAdDidLoad:)]) {
        [delegate tapitInterstitialAdDidLoad:self];
    }
}

- (void)adView:(TapItAdView *)adView didFailToReceiveAdWithError:(NSError*)error {
    isLoaded = NO;
    if ([delegate respondsToSelector:@selector(tapitInterstitialAd:didFailWithError:)]) {
        [delegate tapitInterstitialAd:self didFailWithError:error];
    }    
}

- (BOOL)adActionShouldBegin:(NSURL *)actionUrl willLeaveApplication:(BOOL)willLeave {
    BOOL shouldLoad = YES;
    if ([delegate respondsToSelector:@selector(tapitInterstitialAdActionShouldBegin:willLeaveApplication:)]) {
        shouldLoad = [delegate tapitInterstitialAdActionShouldBegin:self willLeaveApplication:willLeave];
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

- (void)adViewActionDidFinish:(TapItAdView *)adView {
    // This method should always be overridden by child class
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
