//
//  TapItAdManager.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TapItAdManager.h"
#import "TapItRequest.h"
#import "TapItAppTracker.h"
#import "JSONKit.h"

@implementation TapItAdManager
/**
 * handles requesting and producing ad view blocks
 */

@synthesize delegate, params, currentConnection, currentRequest;

- (TapItAdManager *)init {
    if (self = [super init]) {
        params = [[[NSMutableDictionary alloc] initWithCapacity:10] retain];
    }
    
    return self;
}

- (void)requestBannerAdWithParams:(NSDictionary *)theParams {
    [self cancelAdRequests];
    [self setParams:theParams];
    [self fireAdRequest];
}

- (void)fireAdRequest {
    // generate a url form params
    currentRequest = [TapItRequest requestWithParams:params];
    self.currentConnection = [[NSURLConnection connectionWithRequest:currentRequest delegate:self] retain];
    if (self.currentConnection) {
        connectionData = [[NSMutableData data] retain];
    }
    else {
        NSLog(@"Couldn't create a request connection");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [connectionData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString* rawResults = [[NSString alloc] initWithData:connectionData encoding:NSASCIIStringEncoding];
//    NSLog(@"Got this data: %@", rawResults);
    
    currentRequest.rawResults = rawResults;

    [self setCurrentConnection:nil];
    [connectionData release];
    connectionData = nil;
    
    // process connectionData as json
    [self processServerResponse];
}

- (void)processServerResponse {
    NSDictionary *deserializedData = [currentRequest.rawResults objectFromJSONString];
    NSString *errorMsg = [deserializedData objectForKey:@"error"];
    if (!errorMsg) {
        NSLog(@"server returned an error message!");
    }
    NSString *html = [deserializedData objectForKey:@"html"];
    NSString *adType = [deserializedData objectForKey:@"type"]; // html banner ormma offerwall video
    NSString *adHeight = [deserializedData objectForKey:@"adHeight"];
    NSString *adWidth = [deserializedData objectForKey:@"adWidth"];
    NSLog(@"Ad dimentions: %@, %@ (%@)", adHeight, adWidth, adType);
    NSLog(@"This is the HTML we're supposed to use: %@", html);

    // generate an adView based on json object
    // notify delegate listener that ad is rdy
    
    //TODO pick the appropriate adType based on adType returned;
    TapItAdView *adView = [[TapItAdView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    adView.tapitDelegate = self;
    [adView loadHTMLString:html];
}



- (void)willReceiveAd:(id)sender {
    // pass the message on down the receiver chain
    if ([delegate respondsToSelector:@selector(willReceiveAd:)]) {
        [delegate willReceiveAd:sender];
    }
}

- (void)didReceiveAd:(id)sender {
    // pass the message on down the receiver chain
    if ([delegate respondsToSelector:@selector(didReceiveAd:)]) {
        [delegate didReceiveAd:sender];
    }
}

- (void)didFailToReceiveAd:(id)sender withError:(NSError*)error {
    // pass the message on down the receiver chain
    if ([delegate respondsToSelector:@selector(didFailToReceiveAd:withError:)]) {
        [delegate didFailToReceiveAd:sender withError:error];
    }
}

- (void)adWillStartFullScreen:(id)sender {
    // pass the message on down the receiver chain
    if ([delegate respondsToSelector:@selector(adWillStartFullScreen:)]) {
        [delegate adWillStartFullScreen:sender];
    }
}

- (void)adDidEndFullScreen:(id)sender {
    // pass the message on down the receiver chain
    if ([delegate respondsToSelector:@selector(adDidEndFullScreen:)]) {
        [delegate adDidEndFullScreen:sender];
    }
}

- (BOOL)adShouldOpen:(id)sender withUrl:(NSURL*)url {
    // pass the message on down the receiver chain
    if ([delegate respondsToSelector:@selector(adShouldOpen:withUrl:)]) {
        return [delegate adShouldOpen:sender withUrl:url];
    }
    return YES;
}









- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self setCurrentConnection:nil];
    [connectionData release];

    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)cancelAdRequests {
    if (currentConnection) {
        [currentConnection cancel];
        [currentConnection release], currentConnection = nil;
    }
    
    if (connectionData) {
        [connectionData release], connectionData = nil;
    }
}

- (void)dealloc {
    [self cancelAdRequests];

    [params release], params = nil;
    [currentConnection release], currentConnection = nil;
    [currentRequest release], currentRequest = nil;

    [super dealloc];
}

@end
