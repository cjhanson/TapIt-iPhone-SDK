TapIt iOS SDK
=============

Version 2.0 (Beta)

For a complete sample cocos2d application, see https://github.com/tapit/...TODO_NEED_FINAL_URL...

Usage:
======

Add the ```/Lib``` and ```/TapItSDK``` folders into your Xcode project
 - (choose "Copy into destination group's folder...)
 - Check "Create groups for any added folders
 - Check Add to targets for your game's target

Add the following frameworks* to your project if they are not already present:
````
SystemConfiguration.framework
QuartzCore.framework
CoreLocation.framework (optional)
CoreTelephony.framework
````

*To add a framework to your project:
 1. Highlight the project in the Project Navigator
 2. Select your target under "Targets" in the main editor
 3. Choose the Build Phases Tab
 4. Expand the Link Binary with Libraries section
 5. Click the + at the bottom of this window to bring up the framework chooser. (type in the name of a framework to filter the list)
 6. Click Add
 7. Repeat from step 5 for each additional framework

Import the TapItAppTracker at the top of your AppDelegate.m(m) file
````objective-c
//existing import statements
#import "TapItAppTracker.h"
````

Add this to your AppDelegate at the top of application:didFinishLaunchingWithOptions:
````objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[TapItAppTracker sharedAppTracker] reportApplicationOpen];
    //rest of existing app launch code
}
````

In your whatever Scene you want to show an ad, import the following at the top of your scene's .h file
````objective-c
#import "TapIt.h"
````

Banner Usage
------------
In your scene's .h file make your scene conform to the TapItBannerAdViewDelegate protocol
````objective-c
@interface MyScene : CCScene <TapItBannerAdViewDelegate>
````

Then add a property to store the Banner Ad view
````objective-c
@property (retain, nonatomic) TapItBannerAdView *tapitAd;
````

In your scene's .m(m) file add the following to your onEnterTransitionDidFinish method (Replace your Zone ID with that found on your TapItSDK control panel)
````objective-c
- (void) onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGRect bannerRect = CGRectMake((winSize.width - 320)/2, 0, 320, 50);
    self.tapitAd = [[[TapItBannerAdView alloc] initWithFrame:bannerRect] autorelease];
    
    BOOL isTestMode = YES;
    NSDictionary *params = (isTestMode)?[NSDictionary dictionaryWithObjectsAndKeys:@"test", @"mode", nil]:nil;
    
    TapItRequest *request = [TapItRequest requestWithAdZone:@"YOUR ZONE ID" andCustomParameters:params];
    
    self.tapitAd.delegate = self; // notify me of the banner ad's state changes
    [self.tapitAd startServingAdsForRequest:request];
    AppController *app = (AppController*)[[UIApplication sharedApplication] delegate];
    [app.navController.view addSubview:self.tapitAd];
}
````

And the following to your onExitTransitionDidStart
````objective-c
- (void) onExitTransitionDidStart
{
    [super onExitTransitionDidStart];
    
    // We don't want to show ads any more...
    [self.tapitAd cancelAds];
    self.tapitAd = nil;
}
````

Add the following delegate methods to pause/resume the Director
````objective-c
- (BOOL)tapitBannerAdViewActionShouldBegin:(TapItBannerAdView *)bannerView willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"Banner was tapped, your UI will be covered up.");
    // minimise app footprint for a better ad experience.
    // e.g. pause game, duck music, pause network access, reduce memory footprint, etc...
    [[CCDirector sharedDirector] pause];
    return YES;
}

- (void)tapitBannerAdViewActionDidFinish:(TapItBannerAdView *)bannerView
{
    NSLog(@"Banner is done covering your app, back to normal!");
    // resume normal app functions
    [[CCDirector sharedDirector] resume];
}
````

Interstitial (Full screen) Usage
------------------
In your scene's .h file make your scene conform to the TapItInterstitialAdDelegate protocol
````objective-c
@interface MyScene : CCScene <TapItInterstitialAdDelegate>
````

Then add a property to store the ad
````objective-c
@property (retain, nonatomic) TapItInterstitialAd *interstitialAd;
````

In your scene's .m(m) file wherever you want to launch the ad from (probably from a button callback). (Replace your Zone ID with that found on your TapItSDK control panel)
````objective-c
// init and load interstitial
self.interstitialAd = [[[TapItInterstitialAd alloc] init] autorelease];
self.interstitialAd.delegate = self;

BOOL isTestMode = YES;
NSDictionary *params = (isTestMode)?[NSDictionary dictionaryWithObjectsAndKeys:@"test", @"mode", nil]:nil;
TapItRequest *request = [TapItRequest requestWithAdZone:@"YOUR ZONE ID" andCustomParameters:params];
//If using location uncomment the following line
//[request updateLocation:self.locationManager.location];
[self.interstitialAd loadInterstitialForRequest:request];
````

Implement these delegate methods to display the loaded ad when it is ready
````objective-c
- (void)tapitInterstitialAdDidLoad:(TapItInterstitialAd *)interstitialAd
{
    // Ad is ready for display... show it!
    AppController *app = (AppController*)[[UIApplication sharedApplication] delegate];
    [self.interstitialAd presentFromViewController:[app navController]];
    
    [[CCDirector sharedDirector] pause];
}
````

And implement these required delegate methods to release the ad after it is done
````objective-c
- (void)tapitInterstitialAd:(TapItInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    self.interstitialAd = nil;
}

- (void)tapitInterstitialAdDidUnload:(TapItInterstitialAd *)interstitialAd
{
    self.interstitialAd = nil;
    [[CCDirector sharedDirector] resume];
}
````

Listen for location updates (Optional; allows for geo-targeting; requires CoreLocation framework)
---------------------------
In your scene's .h file import the CoreLocation headers and make your scene conform to the CLLocationManagerDelegate protocol
````objective-c
#import <CoreLocation/CoreLocation.h>

@interface MyScene : CCScene <CLLocationManagerDelegate>
````

Then add a property to store the location manager
````objective-c
@property (retain, nonatomic) CLLocationManager *locationManager;
````

In your scene's .m file add the following to the end of your onEnterTransitionDidFinish
````objective-c
- (void) onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];

    // start listening for location updates
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
    [self.locationManager startMonitoringSignificantLocationChanges];
    
    //... Other ad initialization
}
````

Stop monitoring location in onExitTransitionDidStart
````objective-c
- (void) onExitTransitionDidStart
{
    [super onExitTransitionDidStart];
    
    // Stop monitoring location when done to conserve battery life
    [self.locationManager stopMonitoringSignificantLocationChanges];
    self.locationManager = nil;
}
````

Implement the following delegate method
````objective-c
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // Notify the TapIt! banner when the location changes. New location will be used the next time an ad is requested
    [self.tapitAd updateLocation:newLocation];
    
    // Stop monitoring location when done to conserve battery life
    [self.locationManager stopMonitoringSignificantLocationChanges];
    self.locationManager = nil;
}

...


````

For details on the delegate methods called by the TapIt! iOS SDK, see https://github.com/tapit/TapIt-iPhone-SDK/blob/master/TapItSDK/Headers/TapItAdDelegates.h

