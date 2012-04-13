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

@interface TapItAdBase()

- (BOOL)requestAds;
- (void)cancelAds;

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
}

- (id)initWithFrame:(CGRect)frame andAdZone:(NSString *)theAdZone {
    NSLog(@"initWithFrame");
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
//        [self setAdZone:theAdZone];
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

- (BOOL)startServingAds {
    return [super requestAds];
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

- (void)managerHasAdForDisplay:(TapItAdView *)theAd adType:(TapItAdType)type {
    [super managerHasAdForDisplay:theAd adType:type];
    [self moveFrameOnscreen];
}


- (void)dealloc {
    [super dealloc];
}
@end
