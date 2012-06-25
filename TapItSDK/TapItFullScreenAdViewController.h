//
//  TapItFullScreenAdViewController.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TapItAdView;

@interface TapItFullScreenAdViewController : UINavigationController <UIActionSheetDelegate>

@property (retain, nonatomic) TapItAdView *adView; //TODO support video
@property (retain, nonatomic) UIActionSheet *actionSheet;
@property (retain, nonatomic) UIView *glassView;

@end
