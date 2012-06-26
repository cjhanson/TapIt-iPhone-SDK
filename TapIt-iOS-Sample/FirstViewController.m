//
//  FirstViewController.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "TapIt.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewWillAppear:(BOOL)animated {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tapitAd.delegate = self;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:  
//                                @"test", @"mode", 
                                @"1", @"cid",
                                [NSNumber numberWithInt:15], TAPIT_PARAM_KEY_BANNER_ROTATE_INTERVAL, 
//                                [NSNumber numberWithInt:15], TAPIT_PARAM_KEY_BANNER_ERROR_TIMEOUT_INTERVAL, 
                                nil];
    TapItRequest *request = [TapItRequest requestWithAdZone:@"3644" andCustomParameters:params];
//    tapitAd.animated = NO;
    [tapitAd startServingAdsForRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [tapitAd repositionToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark -
#pragma mark TapItBannerAdViewDelegate methods

- (void)tapitBannerAdViewWillLoadAd:(TapItBannerAdView *)bannerView {
    NSLog(@"Banner is about to check server for ad...");
}

- (void)tapitBannerAdViewDidLoadAd:(TapItBannerAdView *)bannerView {
    NSLog(@"Banner has been loaded...");
    // Banner view will display automatically if docking is enabled
    // if disabled, you'll want to show bannerView
}

- (void)tapitBannerAdView:(TapItBannerAdView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Banner failed to load, try a different ad network...");
    // Banner view will hide automatically if docking is enabled
    // if disabled, you'll want to hide bannerView
}

- (BOOL)tapitBannerAdViewActionShouldBegin:(TapItBannerAdView *)bannerView willLeaveApplication:(BOOL)willLeave {
    NSLog(@"Banner was tapped, your UI will be covered up.");
    // minimise app footprint for a better ad experience.
    // e.g. pause game, duck music, pause network access, reduce memory footprint, etc...
    return YES;
}

- (void)tapitBannerAdViewActionDidFinish:(TapItBannerAdView *)bannerView {
    NSLog(@"Banner is done covering your app, back to normal!");
    // resume normal app functions
}

@end
