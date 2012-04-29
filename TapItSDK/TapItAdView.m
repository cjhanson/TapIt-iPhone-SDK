//
//  TapItAdView.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TapItAdView.h"
#import "TapItPrivateConstants.h"

@implementation TapItAdView

@synthesize tapitRequest, tapitDelegate, isLoaded;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSLog(@"TapItAdView initing...");
        [self setScrollable:NO];
        self.delegate = self; // UIWebViewDelegate
        self.isLoaded = NO;
    }
    return self;
}

- (void)setScrollable:(BOOL)scrollable {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000 // iOS 5.0+
    if ([self respondsToSelector:@selector(scrollView)]) 
    {
        UIScrollView *scrollView = self.scrollView;
        scrollView.scrollEnabled = scrollable;
        scrollView.bounces = scrollable;
    } 
    else 
#endif
    {
        UIScrollView *scrollView = nil;
        for (UIView *v in self.subviews)
        {
            if ([v isKindOfClass:[UIScrollView class]])
            {
                scrollView = (UIScrollView *)v;
                break;
            }
        }
        scrollView.scrollEnabled = scrollable;
        scrollView.bounces = scrollable;
    }
}

- (void)loadHTMLString:(NSString *)data {
    NSString *width = @"width:320px; margin:0 auto; text-align:center";
    NSString *htmlData = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">body {margin:0; padding:0;}</style></head><body><div style=\"%@\">%@</div></body></html>", width, data];
//    NSLog(@"Loading this html: %@", htmlData);
    [super loadHTMLString:htmlData baseURL:nil];
    //        NSString *urlString = @"http://google.com";
    //        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //        [self loadRequest:request];

}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.isLoaded = YES;
    NSLog(@"adManager: webViewDidFinishLoad");
    
    if ([self.tapitDelegate respondsToSelector:@selector(didReceiveAd:)]) {
        [self.tapitDelegate didReceiveAd:webView];
    }
    else {
        NSLog(@"Delegate doesn't respond to managerHasAdForDisplay:adType:");
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"webView:didFailLoadWithError:");
    //TODO: call delegate fn
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (!self.isLoaded) {
        // first time loading, let the ad load
        return YES;
    }
    else {
        BOOL shouldOpen = NO;
        if ([self.tapitDelegate respondsToSelector:@selector(adShouldOpen:withUrl:)]) {
            // somewhere down the responder chain, we'll find someone that handles loading the ad in a TapItAdBrowserController...
            // if not, just let load in the tiny ad view box...
            shouldOpen = [self.tapitDelegate adShouldOpen:webView withUrl:[request URL]]; // the ad may have already been loaded by now...
        }
        
        return shouldOpen;
    }
}

- (void)dealloc {
    [tapitRequest release], tapitRequest = nil;
    
    [super dealloc];
}

@end
