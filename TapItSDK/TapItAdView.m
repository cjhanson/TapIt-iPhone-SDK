//
//  TapItAdView.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TapItAdView.h"

@implementation TapItAdView

@synthesize tapitRequest;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSLog(@"TapItAdView initing...");
        [self setScrollable:NO];
//        [self loadHTMLString:@"<a href=\"http://www.tapit.com/\"><img src=\"http://www.google.com/images/srpr/logo3w.png\" width=\"100\" /></a>"];
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
    NSLog(@"Loading this html: %@", htmlData);
    [super loadHTMLString:htmlData baseURL:nil];
    //        NSString *urlString = @"http://google.com";
    //        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //        [self loadRequest:request];

}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
    //TODO: call delegate fn
//    if ([self.delegate respondsToSelector:@selector(adDidLoad:)]) {
//        [self.delegate adDidLoad:self];
//    }

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"webView:didFailLoadWithError:");
    //TODO: call delegate fn
}
@end
