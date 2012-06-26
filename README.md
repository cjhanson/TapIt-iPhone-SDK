TapIt-iPhone-SDK
================
=======
TapIt iOS SDK
=============

Version 2.0 (Development)

**This Software is under construction. Things may change, use at your own risk.**



Usage:
======

Banner Usage
------------
````objective-c
@property (retain, nonatomic) TapItBannerAdView *tapitAd;

...

TapItRequest *request = [TapItRequest requestWithAdZone:@"YOUR ZONE ID" andCustomParameters:params];
self.tapitAd.delegate = self; // notify me of the banner ad's state changes
[self.tapitAd startServingAdsForRequest:request];

...

// We don't want to show ads any more...
[self.tapitAd cancelAds];
````

Interstitial Usage
------------------
Show modally
````objective-c
@property (retain, nonatomic) TapItInterstitialAd *interstitialAd;

...

// init and load interstitial
self.interstitialAd = [[[TapItInterstitialAd alloc] init] autorelease];
self.interstitialAd.delegate = self; // notify me of the interstitial's state changes
TapItRequest *request = [TapItRequest requestWithAdZone:@"YOUR ZONE ID"];
[self.interstitialAd loadInterstitialForRequest:request];

...

- (void)tapitInterstitialAdDidLoad:(TapItInterstitialAd *)interstitialAd {
    // Ad is ready for display... show it!
    [self.interstitialAd presentFromViewController:self];
}
````

Include in paged navigation
    
````objective-c
@property (retain, nonatomic) TapItInterstitialAd *interstitialAd;

...

// init and load interstitial
self.interstitialAd = [[[TapItInterstitialAd alloc] init] autorelease];
TapItRequest *request = [TapItRequest requestWithAdZone:@"YOUR ZONE ID"];
[self.interstitialAd loadInterstitialForRequest:request];

...

// if interstitial is ready, show
if( self.interstitialAd.isLoaded ) {
    [self.interstitialAd presentInView:self.view];
}
````
