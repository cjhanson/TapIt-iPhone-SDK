//
//  TapItBannerAd.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TapItAdBannerView.h"
#import "TapitAdView.h"

@interface TapItAdBannerView () {
    TapItAdView *adView;
    CGRect originalFrame;
}

- (void)commonInit;
- (void)setFrameOffscreen;
@end


@implementation TapItAdBannerView

@synthesize adZone, animated, delegate, customVariables;

- (void)commonInit {
    originalFrame = [self frame];
    [self setFrameOffscreen];
    adView = [[TapItAdView alloc] initWithFrame:[self frame]];
    [self addSubview:adView];
    self.animated = YES; //default value
}

- (id)initWithFrame:(CGRect)frame: (NSString *)andAdZone {
    NSLog(@"initWithFrame");
    if (self = [super initWithFrame:frame]) {
        [self setAdZone:andAdZone];
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"initWithCoder");
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)setFrameOffscreen {
    // move the add offscreen to where we can animate it in smoothly
    
    // figure out which edge we're attached to
    // do the move, taking into account the animated property
    if (self.animated) {
        // animate the move
    }
    else {
        // just move it
    }
}
@end
