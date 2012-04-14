//
//  TapItAdBase.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TapItAdBase.h"
#import "TapItAppTracker.h"
#import "TapItAdView.h"
#import "TapItAdManager.h"
#import "TapItAdBrowserController.h"

@interface TapItAdBase() {
    CGRect originalFrame;
    NSMutableDictionary *customParameters;
}

@property (retain, nonatomic) TapItAdView *adView;
@property (retain, nonatomic) TapItAdManager *adManager;

- (void)baseCommonInit;
- (void)setDefaultParams;
- (BOOL)requestAdsForZone:(NSString *)zone;
- (void)cancelAds;
- (void)openURLInFullscreenBrowser:(NSURL *)url;

@end

@implementation TapItAdBase

@synthesize adZone, adView, adManager, delegate;

- (void)baseCommonInit {
    NSLog(@"super commonInt");
    self.adManager = [[TapItAdManager alloc] init];
    adManager.delegate = self;
    customParameters = [[[NSMutableDictionary alloc] initWithCapacity:10] retain];
}

- (id)initWithFrame:(CGRect)frame andAdZone:(NSString *)theAdZone {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseCommonInit];
        [self setCustomParameterString:theAdZone forKey:@"zone"];
        [self setAdZone:theAdZone];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"super initWithCoder");
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"got self");
        [self baseCommonInit];
    }
    return self;
}

- (NSString *)customParameterForKey:(NSString *)key {
    return [customParameters objectForKey:key];
}

- (NSString *)setCustomParameterString:(NSString *)value forKey:(NSString *)key {
    NSString *oldVal = [customParameters objectForKey:key];
    [customParameters setObject:value forKey:key];
    return oldVal;
}

- (NSString *)removeCustomParameterStringForKey:(NSString *)key {
    NSString *oldVal = [customParameters objectForKey:key];
    [customParameters removeObjectForKey:key];
    return oldVal;
}

//- (void)setAdZone:(NSString *)theAdZone {
//    if (adZone == theAdZone)
//    {
//        return;
//    }
//    NSString *oldValue = adZone;
//    adZone = [theAdZone copy];
//    [oldValue release];
//}


- (void)setDefaultParams {
    [self setCustomParameterString:[[TapItAppTracker sharedAppTracker] userAgent] forKey:@"ua"];
    // zone
    // location (if enabled)
    // connection speed
    // 
}



- (BOOL)requestAdsForZone:(NSString *)zone {
    // Tell adManager to start fetching ads
    if (!zone) {
        NSLog(@"can't request ads, zone isn't set!");
        //TODO there must be a better way to handle this...
        return NO;
    }
    
    [self setCustomParameterString:zone forKey:@"zone"];
    [self setDefaultParams];
    [adManager requestBannerAdWithParams:customParameters];
    return YES;
}

- (void)cancelAds {
    // Tell adManager to stop fetching ads
    [adManager cancelAdRequests];
}






- (void)willReceiveAd:(id)sender {
    if ([delegate respondsToSelector:@selector(willReceiveAd:)]) {
        [delegate willReceiveAd:self]; // yes self, don't use sender it's an internal object
    }
}

- (void)didReceiveAd:(id)sender {
    // This method should be overridden by child class
}

- (void)didFailToReceiveAd:(id)sender withError:(NSError*)error {
    if ([delegate respondsToSelector:@selector(didFailToReceiveAd:withError:)]) {
        [delegate didFailToReceiveAd:self withError:error]; // yes self, don't use sender it's an internal object
    }
}

- (void)adWillStartFullScreen:(id)sender {
    if ([delegate respondsToSelector:@selector(adWillStartFullScreen:)]) {
        [delegate adWillStartFullScreen:self]; // yes self, don't use sender it's an internal object
    }
}

- (void)adDidEndFullScreen:(id)sender {
    if ([delegate respondsToSelector:@selector(adDidEndFullScreen:)]) {
        [delegate adDidEndFullScreen:self]; // yes self, don't use sender it's an internal object
    }
}

- (void)openURLInFullscreenBrowser:(NSURL *)url {
    // Present ad browser.
    TapItAdBrowserController *browserController = [[TapItAdBrowserController alloc] initWithURL:url delegate:self];
    [(UIViewController *)self.delegate presentModalViewController:browserController animated:YES]; //TODO is this cast safe?
    [browserController release];
}

//- (BOOL)adShouldOpen:(id)sender withUrl:(NSURL*)url {
//    BOOL shouldOpen = YES;
//    
//    if ([delegate respondsToSelector:@selector(adShouldOpen:withUrl:)]) {
//        shouldOpen = [delegate adShouldOpen:self withUrl:url]; // yes self, don't use sender it's an internal object
//    }
//    
//    if (shouldOpen) {
//    }
//    
//    // we don't care at this point...
//    return shouldOpen;
//}

- (void)dismissBrowserController:(TapItAdBrowserController *)browserController {
    [self dismissBrowserController:browserController animated:YES];
}

- (void)dismissBrowserController:(TapItAdBrowserController *)browserController animated:(BOOL)animated {
    //	_adActionInProgress = NO;
	[(UIViewController *)self.delegate dismissModalViewControllerAnimated:YES];
	
    //	if ([self.adView.delegate respondsToSelector:@selector(didDismissModalViewForAd:)])
    //		[self.adView.delegate didDismissModalViewForAd:self.adView];
    //	
    //	if (_autorefreshTimerNeedsScheduling)
    //	{
    //		[self.autorefreshTimer scheduleNow];
    //		_autorefreshTimerNeedsScheduling = NO;
    //	}
    //	else if ([self.autorefreshTimer isScheduled]) [self.autorefreshTimer resume];
}





- (void)dealloc {
    [adManager cancelAdRequests];
    [adManager release], adManager = nil;
    [adView release], adView = nil;
    [adZone release], adZone = nil;
    [customParameters release], customParameters = nil;
    
    [super dealloc];
}
@end
