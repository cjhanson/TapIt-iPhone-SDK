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
    
    if ([(NSObject *)self.delegate respondsToSelector:@selector(managerHasAdForDisplay:adType:)]) {
        TapItAdView *adView = [[TapItAdView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        adView.delegate = self;
        [adView loadHTMLString:html];
        [delegate managerHasAdForDisplay:adView adType:TapItBannerAdType]; //FIXME hard coded ad type
    }
    else {
        NSLog(@"Delegate doesn't respond to managerHasAdForDisplay:adType:");
    }

}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"adManager: webViewDidFinishLoad");

    if ([(NSObject *)self.delegate respondsToSelector:@selector(managerHasAdForDisplay:adType:)]) {
        [delegate managerHasAdForDisplay:(TapItAdView *)webView adType:TapItBannerAdType]; //FIXME hard coded ad type
    }
    else {
        NSLog(@"Delegate doesn't respond to managerHasAdForDisplay:adType:");
    }

    
    //TODO: call delegate fn
    //    if ([self.delegate respondsToSelector:@selector(adDidLoad:)]) {
    //        [self.delegate adDidLoad:self];
    //    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"webView:didFailLoadWithError:");
    //TODO: call delegate fn
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
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
