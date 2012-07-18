//
//  HelloWorldLayer.m
//  TapIt-iOS-cocos2d-2x-Sample
//
//  Created by CJ Hanson on 7/19/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#define TAP_IT_SDK_ZONE_ID @"YOUR ZONE ID"
#define TAP_IT_SDK_TEST_MODE 1

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"TapItSDK" fontName:@"Marker Felt" fontSize:32];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		
		//
		// TapItSDK demo (Full page ad)
		//
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// Full Ad Menu Item using blocks
		CCMenuItem *itemFull = [CCMenuItemFont itemWithString:@"Show Interstitial Ad" block:^(id sender) {
			self.interstitialAd = [[[TapItInterstitialAd alloc] init] autorelease];
			self.interstitialAd.delegate = self;
			
			NSDictionary *params = (TAP_IT_SDK_TEST_MODE)?[NSDictionary dictionaryWithObjectsAndKeys:@"test", @"mode", nil]:nil;
			TapItRequest *request = [TapItRequest requestWithAdZone:TAP_IT_SDK_ZONE_ID andCustomParameters:params];
			[request updateLocation:self.locationManager.location];
			[self.interstitialAd loadInterstitialForRequest:request];
		}
									   ];
		
		CCMenu *menu = [CCMenu menuWithItems:itemFull, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];

	}
	return self;
}

- (void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
	
	//
	// TapItSDK Demo (banner ad)
	//
	
	CGSize winSize = [CCDirector sharedDirector].winSize;
	CGRect bannerRect = CGRectMake((winSize.width - 320)/2, 0, 320, 50);
	self.tapitAd = [[[TapItBannerAdView alloc] initWithFrame:bannerRect] autorelease];
	
	NSDictionary *params = (TAP_IT_SDK_TEST_MODE)?[NSDictionary dictionaryWithObjectsAndKeys:@"test", @"mode", nil]:nil;
	
	TapItRequest *request = [TapItRequest requestWithAdZone:TAP_IT_SDK_ZONE_ID andCustomParameters:params];
	
	self.tapitAd.delegate = self; // notify me of the banner ad's state changes
	[self.tapitAd startServingAdsForRequest:request];
	
	AppController *app = (AppController*)[[UIApplication sharedApplication] delegate];
	[app.navController.view addSubview:self.tapitAd];
	
	//Location (Optional)
	// start listening for location updates
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void) onExitTransitionDidStart
{
	[super onExitTransitionDidStart];
	
	//
	// TapItSDK Demo (stop loading banner ads)
	//
	
	[self.tapitAd cancelAds];
	
	self.tapitAd = nil;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	self.tapitAd = nil;
	self.interstitialAd = nil;
	self.locationManager = nil;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark TapItSDK delegates

- (void) presentModalViewController:(UIViewController *)vc animated:(BOOL)animated
{
	AppController *app = (AppController*)[[UIApplication sharedApplication] delegate];
	[app.navController presentModalViewController:vc animated:animated];
}

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

- (void)tapitInterstitialAdDidLoad:(TapItInterstitialAd *)interstitialAd
{
    // Ad is ready for display... show it!
    AppController *app = (AppController*)[[UIApplication sharedApplication] delegate];
    [self.interstitialAd presentFromViewController:[app navController]];
    
    [[CCDirector sharedDirector] pause];
}

/**
 Called when an full-screen ad fails to load a new advertisement. (required)
 
 @param interstitialAd The full-screen ad that received the error.
 @param error The error object that describes the problem.
 
 Although the error message informs your application about why the error occurred, normally your application does not need to display the error to the user.
 
 When an error occurs, your delegate should release the ad object.
 */
- (void)tapitInterstitialAd:(TapItInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
	self.interstitialAd = nil;
}

/**
 Called after a full-screen ad disposes of its content. (required)
 
 @param interstitialAd The interstitial ad that disposed of its content.
 
 An ad object may unload its content for a number of reasons, including such cases as when an error occurs, after a user dismisses
 an advertisement that was presented modally, or after an advertisement’s contents have been loaded for a long period of time.
 The ad object automatically removes its contents from the screen if it was already presented to the user.
 Your implementation of this method should release the ad object.
 */
- (void)tapitInterstitialAdDidUnload:(TapItInterstitialAd *)interstitialAd
{
	self.interstitialAd = nil;
	[[CCDirector sharedDirector] resume];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // Notify the TapIt! banner when the location changes. New location will be used the next time an ad is requested
    [self.tapitAd updateLocation:newLocation];
    
    // Stop monitoring location when done to conserve battery life
    [self.locationManager stopMonitoringSignificantLocationChanges];
    self.locationManager = nil;
}

@end
