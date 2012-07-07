//
//  TapItBannerAd.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "TapItBannerAdView.h"
#import "TapitAdView.h"
#import "TapItAppTracker.h"
#import "TapItAdManager.h"
#import "TapItPrivateConstants.h"
#import "TapItAdBrowserController.h"
#import "TapItRequest.h"

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

//- (void)setFrameOffscreen;
- (IBAction)hide;
- (void)startBannerRotationTimerForNormalOrError:(BOOL)isError; //TODO make this read better

@end


@implementation TapItBannerAdView

@synthesize originalFrame, adView, adRequest, adManager, animated, delegate, hideDirection;

- (void)commonInit {
    self.originalFrame = [self frame];
    self.hideDirection = TapItBannerHideNone;
    [self hide]; // hide the ad view until we have an ad to place in it
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

- (CGRect)getHiddenFrameForDirection:(TapItBannerHideDirection)direction {
    //TODO: Auto direction selection based on ad positioning
    CGRect hiddenFrame = {{0,0}, self.frame.size};
    switch (direction) {
        case TapItBannerHideLeft:
            hiddenFrame.origin.x = - hiddenFrame.size.width;
            break;
            
        case TapItBannerHideRight:
            hiddenFrame.origin.x = hiddenFrame.size.width;
            break;
            
        case TapItBannerHideUp:
            hiddenFrame.origin.y = - hiddenFrame.size.height;
            break;
            
        case TapItBannerHideDown:
            hiddenFrame.origin.y = hiddenFrame.size.height;
            break;
        case TapItBannerHideNone:
        default:
            break;
    }
    
    return hiddenFrame;
}

- (IBAction)hide {
    if (!self.adView) {
        // no ad, hide the container
        self.alpha = 0.0;
        return;
    }
    
    CGRect avFrame = [self getHiddenFrameForDirection:self.hideDirection];
    if (self.animated) {
        // mask the ad area so we can slide it away
        // mask should be reset here, just in case the ad size changes
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.adView.frame.size.width, self.adView.frame.size.height)];
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
        
        UIViewAnimationTransition trans = UIViewAnimationTransitionNone;
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:trans
                         animations:^{
                             if (self.hideDirection == TapItBannerHideNone) {
                                 self.alpha = 0.0;
                             }
                             self.adView.frame = avFrame;
                         }
                         completion:^(BOOL finished){ 
                             self.alpha = 0.0;
                         }
         ];
    }
    else {
        // just move it
        self.adView.frame = avFrame;
        self.alpha = 0.0;
    }
}
#pragma mark -
#pragma mark TapItAdManagerDelegate methods

- (void)willLoadAdWithRequest:(TapItRequest *)request {
    if ([self.delegate respondsToSelector:@selector(tapitBannerAdViewWillLoadAd:)]) {
        [self.delegate tapitBannerAdViewWillLoadAd:self];
    }
}

//TODO: move animation code into a more appropriate place
//TODO: implement more transitions such as slide, fade, etc...
- (void)didLoadAdView:(TapItAdView *)theAdView {
    TapItAdView *oldAd = [self.adView retain];
    self.alpha = 1.0;
    self.adView = theAdView;
    
    if (self.animated) {
//        // mask the ad area so we can slide it away
//        // mask should be reset here, just in case the ad size changes
//        CAShapeLayer *maskLayer = [CAShapeLayer layer];
//        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.adView.frame.size.width, self.adView.frame.size.height)
//        maskLayer.path = path.CGPath;
//        self.layer.mask = maskLayer;

        UIViewAnimationTransition trans = UIViewAnimationTransitionCurlDown; //(nil != self.adView ? [self getRandomTransition] : UIViewAnima
        [UIView animateWithDuration:1
                              delay:0.0
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
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
    
    [self startBannerRotationTimerForNormalOrError:NO];
    
    if ([self.delegate respondsToSelector:@selector(tapitBannerAdViewDidLoadAd:)]) {
        [self.delegate tapitBannerAdViewDidLoadAd:self];
    }
    
    [oldAd release];
}

- (void)adView:(TapItAdView *)adView didFailToReceiveAdWithError:(NSError*)error {
    if ([self.delegate respondsToSelector:@selector(adView:didFailToReceiveAdWithError:)]) {
        [self.delegate tapitBannerAdView:self didFailToReceiveAdWithError:error];
    }
    [self hide];
    [self startBannerRotationTimerForNormalOrError:YES];
}

- (BOOL)adActionShouldBegin:(NSURL *)actionUrl willLeaveApplication:(BOOL)willLeave {
    if ([self.delegate respondsToSelector:@selector(tapitBannerAdViewActionShouldBegin:willLeaveApplication:)]) {
        BOOL shouldLoad = [self.delegate tapitBannerAdViewActionShouldBegin:self willLeaveApplication:willLeave];
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
    if ([self.delegate respondsToSelector:@selector(tapitBannerAdViewActionDidFinish:)]) {
        [self.delegate tapitBannerAdViewActionDidFinish:self];
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
    [self requestAnotherAd];
}

- (void)stopTimer {
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
    [browserController dismissModalViewControllerAnimated:YES];
	[self.delegate tapitBannerAdViewActionDidFinish:self];
    [self requestAnotherAd];
}

#pragma mark -
#pragma mark geotargeting code
- (NSUInteger)locationPrecision {
    return self.adRequest.locationPrecision;
}

- (void)setLocationPrecision:(NSUInteger)locationPrecision {
    if (locationPrecision != self.adRequest.locationPrecision) {
        self.adRequest.locationPrecision = locationPrecision;
    }
}

- (void)updateLocation:(CLLocation *)location {
    [self.adRequest updateLocation:location];
}

#pragma mark -

- (void)dealloc {
    [self cancelAds];
    self.adView = nil;
    self.adRequest = nil;
    self.adManager = nil;
    self.delegate = nil;
    
    [super dealloc];
}
@end
