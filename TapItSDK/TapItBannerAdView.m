//
//  TapItBannerAd.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TapItBannerAdView.h"
#import "TapitAdView.h"
#import "TapItAppTracker.h"
#import "TapItAdManager.h"
#import "TapItPrivateConstants.h"
#import "TapItAdBrowserController.h"

@interface TapItBannerAdView () <TapItAdManagerDelegate, TapItAdBrowserControllerDelegate> {
    NSTimer *timer;
    BOOL isServingAds;
}

@property (retain, nonatomic) TapItRequest *adRequest;
@property (retain, nonatomic) TapItAdView *adView;
@property (retain, nonatomic) TapItAdManager *adManager;
@property (assign, nonatomic) CGRect originalFrame;

- (void)commonInit;
- (void)openURLInFullscreenBrowser:(NSURL *)url;
- (UIViewAnimationTransition)getRandomTransition;

- (void)setFrameOffscreen;
- (void)startBannerRotationTimerForNormalOrError:(BOOL)isError; //TODO make this read better

@end


@implementation TapItBannerAdView

@synthesize originalFrame, adView, adRequest, adManager, animated, delegate;

- (void)commonInit {
    self.originalFrame = [self frame];
    [self setFrameOffscreen]; // hide the ad view until we have an ad to place in it
    self.animated = YES; //default value
    self.adManager = [[[TapItAdManager alloc] init] autorelease];
    self.adManager.delegate = self;
    isServingAds = NO;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (BOOL)startServingAdsForRequest:(TapItRequest *)request {
    self.adRequest = request;
    [self.adManager fireAdRequest:self.adRequest];
    isServingAds = YES;
    return YES;
}

- (void)moveFrameOnscreen {
    if (self.animated) {
        //TODO implement me!
        // animate move
    }
    else {
        NSLog(@"moveFrameOnscreen");
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        [self repositionToInterfaceOrientation:orientation];
//        [self setFrame:originalFrame];
    }
}


- (void)repositionToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        // swap width <--> height
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    
    CGFloat x = 0, y = 0;
    CGFloat w = self.adView.frame.size.width, h = self.adView.frame.size.height;

    x = size.width/2 - self.adView.frame.size.width/2;

    if(self.animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setFrame:CGRectMake(x, y, w, h)];
        }
                         completion:^(BOOL finished){}
        ];
    }
    else {
        [self setFrame:CGRectMake(x, y, w, h)];
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

#pragma mark -
#pragma mark TapItAdManagerDelegate methods

- (void)willLoadAdWithRequest:(TapItRequest *)request {
    if ([delegate respondsToSelector:@selector(tapitBannerAdViewWillLoadAd:)]) {
        [delegate tapitBannerAdViewWillLoadAd:self];
    }
}

//TODO: move animation code into a more appropriate place
//TODO: implement more transitions such as slide, fade, etc...
- (void)didLoadAdView:(TapItAdView *)theAdView {
//    NSLog(@"adView frame: %@", adView.frame);
    TapItAdView *oldAd = [self.adView retain];
    self.adView = theAdView;
    
    if (self.animated) {
        UIViewAnimationTransition trans = (nil != self.adView ? [self getRandomTransition] : UIViewAnimationTransitionCurlDown);
        [UIView animateWithDuration:1 animations:^{
                                        [UIView setAnimationTransition:trans forView:self cache:YES];
                                        [self addSubview:self.adView];
                                      }
                                      completion:^(BOOL finished){ 
                                          [oldAd removeFromSuperview];
                                      }
        ];
    }
    else {
        [self addSubview:self.adView];
        [oldAd removeFromSuperview];
    }
    
    
    NSLog(@"animating didReceiveAd!");
    [self moveFrameOnscreen];

    [self startBannerRotationTimerForNormalOrError:NO];
    
    if ([delegate respondsToSelector:@selector(tapitBannerAdViewDidLoadAd:)]) {
        [delegate tapitBannerAdViewDidLoadAd:self];
    }
    
    [oldAd release];
}

- (void)adView:(TapItAdView *)adView didFailToReceiveAdWithError:(NSError*)error {
    NSLog(@"ERRRRRRRRRR from bannerview");
    if ([delegate respondsToSelector:@selector(adView:didFailToReceiveAdWithError:)]) {
        [delegate tapitBannerAdView:self didFailToReceiveAdWithError:error];
    }    
    [self startBannerRotationTimerForNormalOrError:YES];
}

- (BOOL)adActionShouldBegin:(NSURL *)actionUrl willLeaveApplication:(BOOL)willLeave {
    if ([delegate respondsToSelector:@selector(tapitBannerAdViewActionShouldBegin:willLeaveApplication:)]) {
        BOOL shouldLoad = [delegate tapitBannerAdViewActionShouldBegin:self willLeaveApplication:willLeave];
        if (shouldLoad) {
            [self openURLInFullscreenBrowser:actionUrl];
        }
        return shouldLoad;
    }
    else {
        return YES;
    }
}

- (void)adViewActionDidFinish:(TapItAdView *)adView {
    if ([delegate respondsToSelector:@selector(tapitBannerAdViewActionDidFinish:)]) {
        [delegate tapitBannerAdViewActionDidFinish:self];
    }
}

- (void)requestAnotherAd {
    [self startServingAdsForRequest:self.adRequest];
}

- (void)cancelAds {
    // Tell adManager to stop fetching ads
    isServingAds = NO;
    [self stopTimer];
    [adManager cancelAdRequests];
}

#pragma mark -

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

#pragma mark -
#pragma mark Timer methods

- (BOOL)isServingAds {
    return isServingAds;
}

- (void)startTimerForSeconds:(NSTimeInterval)seconds {
    [self stopTimer];
    timer = [[NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(timerElapsed) userInfo:nil repeats:NO] retain];
}

- (void)timerElapsed {
    // fire off another ad request...
    NSLog(@"timerElapsed");
    [self requestAnotherAd];
}

- (void)stopTimer {
    NSLog(@"Stop Timer");
    [timer invalidate];
    [timer release], timer = nil;
}

- (void)startBannerRotationTimerForNormalOrError:(BOOL)isError {
    if (!isServingAds) {
        // banner has been canceled, don't re-start timer
        return;
    }
    
    NSString *key = isError ? TAPIT_PARAM_KEY_BANNER_ERROR_TIMEOUT_INTERVAL : TAPIT_PARAM_KEY_BANNER_ROTATE_INTERVAL;
    NSNumber *durObj = [self.adRequest customParameterForKey:key];
    NSTimeInterval duration;
    if (durObj) {
        duration = [durObj intValue];
    }
    else {
        duration = isError ? TAPIT_PARAM_VALUE_BANNER_ERROR_TIMEOUT_INTERVAL : TAPIT_PARAM_VALUE_BANNER_ROTATE_INTERVAL;
    }
    
    [self startTimerForSeconds:duration];
}

- (UIViewController *)getDelegate {
    return (UIViewController *)self.delegate;
}

#pragma mark -
#pragma mark TapItAdBrowserController methods

- (void)openURLInFullscreenBrowser:(NSURL *)url {
    // Present ad browser.
    TapItAdBrowserController *browserController = [[TapItAdBrowserController alloc] initWithURL:url delegate:self];
    UIViewController *theDelegate = [self getDelegate];
    if (theDelegate) {
        [theDelegate presentModalViewController:browserController animated:YES];
    }
    [browserController release];
}

- (void)dismissBrowserController:(TapItAdBrowserController *)browserController {
    [self dismissBrowserController:browserController animated:YES];
}

- (void)dismissBrowserController:(TapItAdBrowserController *)browserController animated:(BOOL)isAnimated {
	[delegate tapitBannerAdViewActionDidFinish:self];
    [self requestAnotherAd];
}


- (void)dealloc {
    [self cancelAds];
    self.adView = nil;
    self.adRequest = nil;
    self.adManager = nil;
    self.delegate = nil;
    
    [super dealloc];
}
@end
