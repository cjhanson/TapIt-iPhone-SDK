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
#import "TapItAppTracker.h"


@interface TapItRequest () 

@property (retain, nonatomic) NSString *adZone;
@property (retain, nonatomic) NSMutableDictionary *parameters;
@property (retain, nonatomic) NSString *rawResults;

+(NSArray *)allowedServerVariables; //TODO probably needs to be moved to bannerview/interstitialcontroller

- (NSURLRequest *)getURLRequest;

@end

@implementation TapItRequest

@synthesize adZone, parameters, rawResults;


+ (TapItRequest *)requestWithAdZone:(NSString *)zone {
    return [TapItRequest requestWithAdZone:zone andCustomParameters:nil];
}

+ (TapItRequest *)requestWithAdZone:(NSString *)zone andCustomParameters:(NSDictionary *)theParams {
    TapItRequest *ret = [[[TapItRequest alloc] init] autorelease];
    ret.adZone = zone;
    if (theParams) {
        [ret.parameters addEntriesFromDictionary:theParams];
    }
    return ret;
}

- (id)init {
    self = [super init];
    if (self) {
        self.parameters = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return self;
}

- (NSURLRequest *)getURLRequest {
    //TODO add in missing required fields and filter out invalid params
    [self setDefaultParams];
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",
                        TAPIT_AD_SERVER_URL,
                        [self.parameters queryStringWithAllowedKeys:[TapItRequest allowedServerVariables]]
                        ];
//    NSLog(@"%@", urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [[[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0] autorelease];
    return req;
    
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
                                  @"adtype",
                                  //TODO finish this list...
                                  nil] retain];
    }
    
    return allowedServerVariables;
}

#pragma mark -
#pragma mark customParams methods

- (id)customParameterForKey:(NSString *)key {
    return [parameters objectForKey:key];
}

- (id)setCustomParameter:(id)value forKey:(NSString *)key {
    NSString *oldVal = [parameters objectForKey:key];
    [parameters setObject:value forKey:key];
    return oldVal;
}

- (id)removeCustomParameterForKey:(NSString *)key {
    NSString *oldVal = [parameters objectForKey:key];
    [parameters removeObjectForKey:key];
    return oldVal;
}

- (void)setDefaultParams {
    [self setCustomParameter:self.adZone forKey:@"zone"];
    [self setCustomParameter:@"json" forKey:@"format"];
    TapItAppTracker *tracker = [TapItAppTracker sharedAppTracker];
    [self setCustomParameter:[tracker deviceUDID] forKey:@"udid"];
    [self setCustomParameter:[tracker userAgent] forKey:@"ua"];
    // location (if enabled)
    // connection speed
    // 
}

-(void)dealloc {
    self.rawResults = nil;
    self.parameters = nil;
    self.adZone = nil;
    
    [super dealloc];
}
@end
