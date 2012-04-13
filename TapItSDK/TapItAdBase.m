//
//  TapItAdBase.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TapItAdBase.h"
#import "TapItAppTracker.h"

@interface TapItAdBase() {
    CGRect originalFrame;
    NSMutableDictionary *customParameters;
}

@property (retain, nonatomic) TapItAdView *adView;
@property (retain, nonatomic) TapItAdManager *adManager;

- (void)baseCommonInit;
- (void)setDefaultParams;
- (BOOL)requestAds;
- (void)cancelAds;

@end

@implementation TapItAdBase

@synthesize adZone, adView, adManager;

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



- (BOOL)requestAds {
    // Tell adManager to start fetching ads
    if (![self customParameterForKey:@"zone"]) {
        NSLog(@"can't request ads, zone isn't set!");
        //TODO there must be a better way to handle this...
        return NO;
    }
    //FIXME get rid of hard coded test code!
    //    [customParameters setValue:@"test" forKey:@"mode"];
    [self setDefaultParams];
    [adManager requestBannerAdWithParams:customParameters];
    return YES;
}

- (void)cancelAds {
    // Tell adManager to stop fetching ads
    [adManager cancelAdRequests];
}

- (void)managerHasAdForDisplay:(TapItAdView *)theAd adType:(TapItAdType)type {
    // show the ad!
    NSLog(@"Got an ad! hook it up and display it!");
    self.adView = theAd;
    [self.adView setFrame:CGRectMake(0, 0, 320, 50)]; //FIXME get rid of hard coded size!
    [self addSubview:adView];
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
