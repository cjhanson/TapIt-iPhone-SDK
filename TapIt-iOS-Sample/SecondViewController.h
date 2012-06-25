//
//  SecondViewController.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapItAdDelegates.h"

enum {
    StateLoading    = 1,
    StateError      = 2,
    StateReady      = 3,
};
typedef NSUInteger ButtonState;


@class TapItInterstitialAd;

@interface SecondViewController : UIViewController <TapItInterstitialAdDelegate> 

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UIButton *loadButton;
@property (retain, nonatomic) IBOutlet UIButton *showButton;

@property (retain, nonatomic) TapItInterstitialAd *interstitialAd;

- (IBAction)loadInterstitial:(id)sender;
- (IBAction)showInterstitial:(id)sender;

- (void)updateUIWithState:(ButtonState)state;
@end
