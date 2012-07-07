//
//  TapItAppTracker.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TapItAppTracker : NSObject

+ (TapItAppTracker *)sharedAppTracker;

- (NSString *)deviceUDID;
- (NSString *)userAgent;
- (CLLocation *)location;
- (NSInteger)networkConnectionType;

- (void)reportApplicationOpen;

@end
