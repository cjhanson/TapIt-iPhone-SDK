TapIt iOS SDK
=============

Version 2.0 (Beta)



Usage:
======
Copy the ```/Lib``` and ```/TapItSDK``` folders into your Xcode project.  The following frameworks are required:
````
SystemConfiguration.framework
QuartsCore.framework
CoreLocation.framework
````

Banner Usage
------------
````objective-c
@property (retain, nonatomic) TapItBannerAdView *tapitAd;

...

// if not passing in any params:
TapItRequest *request = [TapItRequest requestWithAdZone:@"YOUR ZONE ID"];

// --OR--

// for test mode
NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"test", @"mode", nil];
TapItRequest *request = [TapItRequest requestWithAdZone:@"YOUR ZONE ID" andCustomParameters:params];

self.tapitAd.delegate = self; // notify me of the banner ad's state changes
[self.tapitAd startServingAdsForRequest:request];

...

// We don't want to show ads any more...
[self.tapitAd cancelAds];
````

For a complete example, see https://github.com/tapit/TapIt-iPhone-SDK/blob/master/TapIt-iOS-Sample/FirstViewController.m


Listen for location updates
---------------------------
If you want to allow for geo-targeting, listen for location updates:
````objective-c
@property (retain, nonatomic) CLLocationManager *locationManager;

...

// start listening for location updates
self.locationManager = [[CLLocationManager alloc] init];
self.locationManager.delegate = self;
[self.locationManager startMonitoringSignificantLocationChanges];

...

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // Notify the TapIt! banner when the location changes.  New location will be used the next time an ad is requested
    [self.tapitAd updateLocation:newLocation];
}

...

// Stop monitoring location when done to conserve battery life
[self.locationManager stopMonitoringSignificantLocationChanges];
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
For a complete example, see https://github.com/tapit/TapIt-iPhone-SDK/blob/master/TapIt-iOS-Sample/SecondViewController.m

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

For details on the delegate methods called by the TapIt! iOS SDK, see https://github.com/tapit/TapIt-iPhone-SDK/blob/master/TapItSDK/Headers/TapItAdDelegates.h