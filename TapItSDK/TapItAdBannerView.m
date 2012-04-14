//
//  TapItBannerAd.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TapItAdBannerView.h"
#import "TapitAdView.h"
#import "TapItAppTracker.h"
#import "TapItAdManager.h"

@class TapItAdManager;

@interface TapItAdBase()

@property (retain, nonatomic) TapItAdView *adView;
@property (retain, nonatomic) TapItAdManager *adManager;

- (BOOL)requestAdsForZone:(NSString *)zone;
- (void)cancelAds;
- (void)openURLInFullscreenBrowser:(NSURL *)url;

@end

@interface TapItAdBannerView () 
- (void)commonInit;
- (void)setFrameOffscreen;
@end


@implementation TapItAdBannerView

@synthesize animated, delegate;

- (void)commonInit {
    NSLog(@"child commonInit");
//    originalFrame = [self frame];
    [self setFrameOffscreen]; // hide the ad view until we have an ad to place in it
//    self.animated = YES; //default value
    self.animated = NO;
    self.adManager.delegate = self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"initWithCoder");
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"child got self");
        [self commonInit];
    }
    return self;
}

- (BOOL)startServingAdsForZone:(NSString *)zone {
    self.adZone = zone;
    return [super requestAdsForZone:zone];
}

- (void)moveFrameOnscreen {
    if (self.animated) {
        //TODO implement me!
        // animate move
    }
    else {
        NSLog(@"moveFrameOnscreen");
        [self setFrame:CGRectMake(0, 0, 320, 50)];
//        [self setFrame:originalFrame];
    }
}

- (void)setFrameOffscreen {
    //TODO implement me!
    // move the add offscreen to where we can animate it in smoothly
    
    // figure out which edge we're attached to
    // do the move, taking into account the animated property
    if (self.animated) {
        // animate the move
    }
    else {
        // just move it
        [self setFrame:CGRectZero];
    }
}

- (void)didReceiveAd:(id)sender {
    self.adView = (TapItAdView *)sender;
    [self.adView setFrame:CGRectMake(0, 0, 320, 50)]; //FIXME get rid of hard coded size!
    [self addSubview:self.adView];
    [self moveFrameOnscreen];
    if ([delegate respondsToSelector:@selector(didReceiveAd:)]) {
        [delegate didReceiveAd:self]; // yes self, don't use sender it's an internal object
    }
}

- (BOOL)adShouldOpen:(id)sender withUrl:(NSURL*)url {
    BOOL shouldOpen = YES;
    
    if ([delegate respondsToSelector:@selector(adShouldOpen:withUrl:)]) {
        shouldOpen = [delegate adShouldOpen:self withUrl:url]; // yes self, don't use sender it's an internal object
    }
    
    if (shouldOpen) {
        [self openURLInFullscreenBrowser:url];
        shouldOpen = NO;
    }
    
    return shouldOpen;
}

- (void)dealloc {
    [super dealloc];
}
@end
