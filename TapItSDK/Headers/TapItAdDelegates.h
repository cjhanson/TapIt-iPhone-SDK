//
//  TapItAdMobileViewDelegate.h
//  TapItAdMobile
//
//  Copyright 2012 TapIt! All rights reserved.
//
//

@class TapItBannerAdView;

@protocol TapItBannerAdViewDelegate <NSObject>
@optional

/**
 Called before a new banner advertisement is loaded.
 
 @param bannerView The banner view that is about to a new advertisement.
 */
- (void)tapitBannerAdViewWillLoadAd:(TapItBannerAdView *)bannerView;

/**
 Called when a new banner advertisement is loaded.
 
 @param bannerView The banner view that loaded a new advertisement.
 */
- (void)tapitBannerAdViewDidLoadAd:(TapItBannerAdView *)bannerView;

/**
 Called when a banner view fils to load a new advertisement.
 
 @param bannerView The banner view that failed to load an advertisement.
 @param error The error object that describes the problem.
 */
- (void)tapitBannerAdView:(TapItBannerAdView *)bannerView didFailToReceiveAdWithError:(NSError *)error;

/**
 Called before a banner view executes an action.
 
 @param bannerView The banner view that the user tapped.
 @param willLeave YES if another application will be launched to execute the action; NO if the action is going to be executed inside your appliaction.
 
 @return Your delegate returns YES if the banner action should execute; NO to prevent the banner action from executing.
 
 This method is called when the user taps the banner view. Your application controls whether the action is triggered. To allow the action to be triggered, 
 return YES. To suppress the action, return NO. Your application should almost always allow actions to be triggered; preventing actions may alter the 
 advertisements your application sees and reduce the revenue your application earns through TapIt.
 
 If the willLeave parameter is YES, then your application is moved to the background shortly after this method returns. In this situation, your method 
 implementation does not need to perform additional work. If willLeave is set to NO, then the triggered action will cover your application’s user 
 interface to show the advertising action. Although your application continues to run normally, your implementation of this method should disable 
 activities that require user interaction while the action is executing. For example, a game might pause its game play until the user finishes 
 watching the advertisement.
 
 */
- (BOOL)tapitBannerAdViewActionShouldBegin:(TapItBannerAdView *)bannerView willLeaveApplication:(BOOL)willLeave;

/**
 Called after a banner view finishes executing an action that covered your application's user interface.

 @param bannerView The banner view that finished executing an action.
 */
- (void)tapitBannerAdViewActionDidFinish:(TapItBannerAdView *)bannerView;

@end



@class TapItInterstitialAd;

@protocol TapItInterstitialAdDelegate <NSObject>
@required

/**
 Called when an full-screen ad fails to load a new advertisement. (required)
 
 @param interstitialAd The full-screen ad that received the error.
 @param error The error object that describes the problem.
 
 Although the error message informs your application about why the error occurred, normally your application does not need to display the error to the user.
 
 When an error occurs, your delegate should release the ad object.
 */
- (void)tapitInterstitialAd:(TapItInterstitialAd *)interstitialAd didFailWithError:(NSError *)error;

/**
 Called after a full-screen ad disposes of its content. (required)
 
 @param interstitialAd The interstitial ad that disposed of its content.
 
 An ad object may unload its content for a number of reasons, including such cases as when an error occurs, after a user dismisses 
 an advertisement that was presented modally, or after an advertisement’s contents have been loaded for a long period of time. 
 The ad object automatically removes its contents from the screen if it was already presented to the user. 
 Your implementation of this method should release the ad object.
 */
- (void)tapitInterstitialAdDidUnload:(TapItInterstitialAd *)interstitialAd;


@optional

/**
 Called before the advertisement loads its content.
 
 @param interstitialAd The ad object that is about to load a new advertisement.
 */
- (void)tapitInterstitialAdWillLoad:(TapItInterstitialAd *)interstitialAd;

/**
 Called after the advertisement loads its content.
 
 @param interstitialAd The ad object that loaded a new advertisement.
 */
- (void)tapitInterstitialAdDidLoad:(TapItInterstitialAd *)interstitialAd;

/**
 Called before a banner view executes an action.
 
 @param interstitialAd The full-screen ad that the user tapped.
 @param willLeave YES if another application will be launched to execute the action; NO if the action is going to be executed inside your appliaction.
 
 @return Your delegate returns YES if the banner action should execute; NO to prevent the banner action from executing.
 
 When the user taps a presented advertisement, the ad’s delegate is called to inform your application that the user wants to interact with the ad. 
 To allow the action to be triggered, your method should return YES; to suppress the action, your method returns NO. Your application should almost 
 always allow actions to be triggered; preventing actions may alter the advertisements your application sees and reduce the revenue your application earns through TapIt.
 
 If the value of the willLeave parameter is YES and your delegate allows the advertisement to execute its action, then your application is moved to 
 the background shortly after the call to this method completes.
 
 If the value of the willLeave parameter is NO, the advertisement’s interactive experience will run inside your application. To accomodate the advertisement, 
 your application should disable activities that require user interaction as well as disabling any tasks or behaviors that may interfere with the advertisement. 
 For example, a game might pause its game play and turn off sound effects until the user finishes interacting with the advertisement. Further, while the 
 action is running, your application should also be prepared to respond to low-memory warnings by disposing of objects it can easily recreate after the 
 advertisement completes its action.
 
 */
- (BOOL)tapitInterstitialAdActionShouldBegin:(TapItInterstitialAd *)interstitialAd willLeaveApplication:(BOOL)willLeave;

/**
 Called after a banner view finishes executing an action that covered your application's user interface.
 
 @param interstitialAd The full-screen ad that finished executing an action.
 */
- (void)tapitInterstitialAdActionDidFinish:(TapItInterstitialAd *)interstitialAd;

@end











//
//
//
//#pragma mark -
//#pragma mark old delegate methods
//
///** Sent before an ad view will begin loading ad content.
// 
// @param sender The ad view that is about to load ad content.
// */
//- (void)willReceiveAd:(id)sender;
//
///** Sent after an ad view finished loading ad content.
// 
// @param sender The ad view has finished loading.
// */
//- (void)didReceiveAd:(id)sender;
//
///** Sent if an ad view failed to load ad content.
// 
// @param sender The ad view that failed to load ad content.
// @param error The error that occurred during loading.
// */
//- (void)didFailToReceiveAd:(id)sender withError:(NSError*)error;
//
///** Sent before an ad view will start to display internal browser.
// 
// @warning *Important:* This method called after adShouldOpen:withUrl: returns YES or not implemented.
// 
// @param sender The ad view that is about to display internal browser.
// */
//- (void)adWillStartFullScreen:(id)sender;
//
///** Sent after an ad view finished displaying internal browser.
// 
// @param sender The ad view has finished displaying internal browser.
// */
//- (void)adDidEndFullScreen:(id)sender;
//
///** Sent before an ad view will start to open URL.
// 
// Implement this method with return NO value if you want to control opening ads by your self.
// 
// This method is optional. If you do not implement this method, the SDK accept YES as return value.
// 
// @param sender The ad view that is about to open URL.
// @param url The URL that should be opened in internal or external browser.
// @return Returns YES to allow SDK open browser otherwise returns NO.
// */
//- (BOOL)adShouldOpen:(id)sender withUrl:(NSURL*)url;
//
//@end
