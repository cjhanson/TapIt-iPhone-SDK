//
//  TapItAdView.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapItAdManagerDelegate.h"
#import "TapItAdDelegate.h"
#import "TapItConstants.h"

@class TapItRequest;

@interface TapItAdView : UIWebView <UIWebViewDelegate>

@property (retain, nonatomic) TapItRequest *tapitRequest;
@property (assign, nonatomic) id<TapItAdDelegate> tapitDelegate;
@property (assign, nonatomic) BOOL isLoaded;

- (void)setScrollable:(BOOL)scrollable;
- (void)loadHTMLString:(NSString *)string;
@end
