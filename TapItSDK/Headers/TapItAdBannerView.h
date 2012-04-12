//
//  TapItBannerAd.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapItAdBannerViewDelegate.h"

@interface TapItAdBannerView : UIView

@property (assign, nonatomic) id<TapItAdBannerViewDelegate> delegate;
@property (retain, nonatomic) NSString *adZone;
@property (assign, nonatomic) BOOL animated;
@property (retain, nonatomic) NSDictionary *customVariables;

- (id)initWithFrame:(CGRect)frame: (NSString *)adZone;

@end
