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
#import "TapItPrivateConstants.h"


@class TapItAdManager;

@interface TapItAdBase()

@property (retain, nonatomic) TapItAdView *adView;
@property (retain, nonatomic) TapItAdManager *adManager;

- (BOOL)requestAdsForZone:(NSString *)zone;
- (void)cancelAds;
- (void)openURLInFullscreenBrowser:(NSURL *)url;
- (UIViewAnimationTransition)getRandomTransition;

@end

@interface TapItAdBannerView () 
- (void)commonInit;
- (void)setFrameOffscreen;
- (void)startBannerRotationTimerForNormalOrError:(BOOL)isError; //TODO make this read better
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

//TODO: move animation code into a more appropriate place
//TODO: implement more transitions such as slide, fade, etc...
- (void)didReceiveAd:(id)sender {
    TapItAdView *oldAd = [self.adView retain];
    UIViewAnimationTransition trans = (nil != self.adView ? [self getRandomTransition] : UIViewAnimationTransitionCurlDown);
    self.adView = (TapItAdView *)sender;
    NSLog(@"animating didReceiveAd!");
    [UIView animateWithDuration:1 animations:^{
                [UIView setAnimationTransition:trans forView:self cache:YES];
                [self addSubview:self.adView];
            }
            completion:^(BOOL finished){ 
                [oldAd removeFromSuperview];
            }
     ];
    [self.adView setFrame:CGRectMake(0, 0, 320, 50)]; //FIXME get rid of hard coded size!
    [self moveFrameOnscreen];
    if ([delegate respondsToSelector:@selector(didReceiveAd:)]) {
        [delegate didReceiveAd:self]; // yes self, don't use sender it's an internal object
    }
    
    [self startBannerRotationTimerForNormalOrError:NO];
    [oldAd release];
}

- (UIViewAnimationTransition)getRandomTransition {
    int transIdx = random() % 5;
    switch (transIdx) {
        case 0:
            return UIViewAnimationTransitionCurlUp;
            break;
            
        case 1:
            return UIViewAnimationTransitionCurlDown;
            break;
            
        case 2:
            return UIViewAnimationTransitionFlipFromLeft;
            break;
            
        case 3:
            return UIViewAnimationTransitionFlipFromRight;
            break;
            
        case 4:
            return UIViewAnimationTransitionNone;
            break;
            
        default:
            return UIViewAnimationTransitionNone;
            break;
    }
}

- (void)didFailToReceiveAd:(id)sender withError:(NSError*)error {
    [super didFailToReceiveAd:sender withError:error];
    [self startBannerRotationTimerForNormalOrError:YES];
}

- (void)startBannerRotationTimerForNormalOrError:(BOOL)isError {
    NSString *key = isError ? TAPIT_PARAM_KEY_BANNER_ERROR_TIMEOUT_INTERVAL : TAPIT_PARAM_KEY_BANNER_ROTATE_INTERVAL;
    NSNumber *durObj = [self customParameterForKey:key];
    NSTimeInterval duration = isError ? TAPIT_PARAM_VALUE_BANNER_ERROR_TIMEOUT_INTERVAL : TAPIT_PARAM_VALUE_BANNER_ROTATE_INTERVAL;
    if (durObj) {
        duration = [durObj intValue];
    }
    else {
        duration = TAPIT_PARAM_VALUE_BANNER_ROTATE_INTERVAL;
    }
    
    [self.adManager startTimerForSeconds:duration];
}

- (void)timerElapsed {
    // fire off another ad request...
    NSString *zone =  [self customParameterForKey:@"zone"];
    NSLog(@"zone: %@", zone);
    [self requestAdsForZone:zone];
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
