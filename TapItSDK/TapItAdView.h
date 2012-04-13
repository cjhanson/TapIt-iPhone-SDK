//
//  TapItAdView.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TapItRequest;

enum {
    TapItBannerAdType = 0x01,
    TapItFullscreenAdType = 0x02,
    TapItVideoAdType = 0x04
};
typedef NSUInteger TapItAdType;

@interface TapItAdView : UIWebView <UIWebViewDelegate>

@property (retain, nonatomic) TapItRequest *tapitRequest;

- (void)setScrollable:(BOOL)scrollable;
- (void)loadHTMLString:(NSString *)string;
@end
