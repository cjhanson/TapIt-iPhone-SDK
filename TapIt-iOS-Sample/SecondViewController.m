//
//  SecondViewController.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "TapIt.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize activityIndicator;
@synthesize loadButton;
@synthesize showButton;
@synthesize interstitialAd;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setLoadButton:nil];
    [self setShowButton:nil];
    [self setActivityIndicator:nil];
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

#pragma mark -
#pragma mark Button handling

- (IBAction)showInterstitial:(id)sender {
    NSLog(@"Show button pressed");
//    [self.interstitialAd presentInView:self.view];
    [self.interstitialAd presentFromViewController:self];
}

- (IBAction)loadInterstitial:(id)sender {
    NSLog(@"Load button pressed");
    [self updateUIWithState:StateLoading];
    self.interstitialAd = [[[TapItInterstitialAd alloc] init] autorelease];
    self.interstitialAd.delegate = self;
//    [self.interstitialAd setCustomParameter:@"test" forKey:@"mode"];
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:  
//                            @"test", @"mode", 
//                            nil];
//    TapItRequest *request = [TapItRequest requestWithZone:@"3644" andCustomParameters:params];
    TapItRequest *request = [TapItRequest requestWithAdZone:@"3644"];
    [self.interstitialAd loadInterstitialForRequest:request];
}

- (void)updateUIWithState:(ButtonState)state {
    [loadButton setEnabled:(state != StateLoading)];
    [showButton setHidden:(state != StateReady)];
    [activityIndicator setHidden:(state != StateLoading)];
}

#pragma mark -
#pragma mark TapItInterstitialAdDelegate methods

- (void)tapitInterstitialAd:(TapItInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error.localizedDescription);
    [self updateUIWithState:StateError];
}

- (void)tapitInterstitialAdDidUnload:(TapItInterstitialAd *)interstitialAd {
    NSLog(@"Ad did unload");
}

- (void)tapitInterstitialAdWillLoad:(TapItInterstitialAd *)interstitialAd {
    NSLog(@"Ad will load");
}

- (void)tapitInterstitialAdDidLoad:(TapItInterstitialAd *)interstitialAd {
    NSLog(@"Ad did load");
    [self updateUIWithState:StateReady];
}

- (BOOL)tapitInterstitialAdActionShouldBegin:(TapItInterstitialAd *)interstitialAd willLeaveApplication:(BOOL)willLeave {
    NSLog(@"Ad action should begin");
    return YES;
}

- (void)tapitInterstitialAdActionDidFinish:(TapItInterstitialAd *)interstitialAd {
    NSLog(@"Ad action did finish");
}


#pragma mark -

- (void)dealloc {
    [loadButton release];
    [showButton release];
    [activityIndicator release];
    [interstitialAd release];
    [super dealloc];
}
@end
