//
//  HelloWorldLayer.h
//  TapIt-iOS-cocos2d-2x-Sample
//
//  Created by CJ Hanson on 7/19/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import "TapIt.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <TapItBannerAdViewDelegate, TapItInterstitialAdDelegate, CLLocationManagerDelegate>
{
}

@property (retain, nonatomic) TapItBannerAdView *tapitAd;
@property (retain, nonatomic) TapItInterstitialAd *interstitialAd;
//Location is optional for the TapItSDK
@property (retain, nonatomic) CLLocationManager *locationManager;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
