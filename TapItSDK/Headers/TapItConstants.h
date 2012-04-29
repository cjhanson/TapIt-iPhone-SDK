//
//  TapItConstants.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef TapIt_iOS_Sample_TapItConstants_h
#define TapIt_iOS_Sample_TapItConstants_h

#define TAPIT_VERSION @"2.0.0"

enum {
    TapItBannerAdType = 0x01,
    TapItFullscreenAdType = 0x02,
    TapItVideoAdType = 0x04
};
typedef NSUInteger TapItAdType;


#define TAPIT_PARAM_KEY_BANNER_ROTATE_INTERVAL @"RotateBannerInterval"
#define TAPIT_PARAM_KEY_BANNER_ERROR_TIMEOUT_INTERVAL @"ErrorRetryInterval"

#endif
