//
//  TapItRequest.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TapItRequest.h"
#import "TapItPrivateConstants.h"
#import "NSDictionary+QueryStringBuilder.h"

@interface TapItRequest ()
+(NSArray *)allowedServerVariables;

@end

@implementation TapItRequest

@synthesize parameters, rawResults;

+ (TapItRequest *)requestWithParams:(NSDictionary *)theParams {
    TapItRequest *ret = [TapItRequest alloc];
    //TODO add in missing required fields and filter out invalid params
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",
                        TAPIT_AD_SERVER_URL,
                        [theParams queryStringWithAllowedKeys:[TapItRequest allowedServerVariables]]
                        ];
    NSLog(@"%@", urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    [ret initWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
    [ret setParameters:theParams];
    return ret;
}

+(NSArray *)allowedServerVariables {
    static NSArray *allowedServerVariables;
    
    if (nil == allowedServerVariables) {
        allowedServerVariables = [[NSArray arrayWithObjects:
                                  @"zone",
                                  @"h",
                                  @"w",
                                  @"ua",
                                  @"udid",
                                  @"format",
                                  @"ip",
                                  @"mode",
                                  @"lat",
                                  @"long",
                                  //TODO finish this list...
                                  nil] retain];
    }
    
    return allowedServerVariables;
}

-(void)dealloc {
    [parameters release], parameters = nil;
    [rawResults release], rawResults = nil;
    
    [super dealloc];
}
@end
