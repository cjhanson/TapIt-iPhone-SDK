//
//  FirstViewController.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TapItAdDelegates.h"

@class TapItBannerAdView;

@interface FirstViewController : UIViewController <TapItBannerAdViewDelegate, CLLocationManagerDelegate> {
    IBOutlet TapItBannerAdView *tapitAd;
}

@property (retain, nonatomic) CLLocationManager *locationManager;

@end
