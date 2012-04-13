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


@implementation TapItRequest

@synthesize parameters, rawResults;

+ (TapItRequest *)requestWithParams:(NSDictionary *)theParams {
    TapItRequest *ret = [TapItRequest alloc];
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",
                        TAPIT_AD_SERVER_URL,
                        [theParams queryString]
                        ];
    NSLog(@"%@", urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    [ret initWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
    [ret setParameters:theParams];
    return ret;
}

-(void)dealloc {
    [parameters release], parameters = nil;
    [rawResults release], rawResults = nil;
    
    [super dealloc];
}
@end
