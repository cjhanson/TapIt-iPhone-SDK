//
//  TapItInterstitialAdViewController.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapItAdDelegates.h"
#import "TapItAdBrowserController.h"

@class TapItAdView;
@class TapItAdBrowserController;

@interface TapItInterstitialAdViewController : UINavigationController <UIActionSheetDelegate, UIWebViewDelegate, TapItAdBrowserControllerDelegate> {
}

@property (retain, nonatomic) TapItAdView *adView;
@property (assign, nonatomic) id<TapItInterstitialAdDelegate> tapitDelegate;
@property (assign, nonatomic) BOOL animated;

- (void)openURLInFullscreenBrowser:(NSURL *)url;

@end
