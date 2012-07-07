//
//  TapItActionSheetAdViewController.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TapItLightboxAdViewController.h"
#import "TapItAdBrowserController.h"
#import "TapItAdView.h"

@interface TapItLightboxAdViewController () <TapItAdBrowserControllerDelegate>

- (void)closeTapped:(id)sender;

@end



@implementation TapItLightboxAdViewController

@synthesize closeButton, tappedURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self.adView setCenter:self.view.center];
    [self.view addSubview:(UIView *)self.adView];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImage *closeButtonBackground = [UIImage imageNamed:@"interstitial_close_button.png"];
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(0, 0, 44, 44);
    self.closeButton.imageView.contentMode = UIViewContentModeCenter;
    [self.closeButton setImage:closeButtonBackground forState:UIControlStateNormal];
    
    CGRect frame = self.closeButton.frame;
    self.closeButton.frame = frame;
    [self.closeButton addTarget:self action:@selector(closeTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
        
    self.navigationBarHidden = YES;
    NSString *callToAction = (NSString *)[self.adView.data objectForKey:@"calltoaction"];
    if(callToAction == nil) {
        callToAction = @"Get More Info";
    }
}

- (void)closeTapped:(id)sender {
    id<TapItInterstitialAdDelegate> tDel = [self.tapitDelegate retain];
    [self dismissViewControllerAnimated:self.animated completion:^{
        [tDel tapitInterstitialAdActionDidFinish:nil];
        [tDel tapitInterstitialAdDidUnload:nil];
        [tDel release];
    }];
}

- (void)viewDidUnload
{
    self.closeButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark -


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL shouldLoad = YES;
    if (self.tapitDelegate) {
        if ([self.tapitDelegate respondsToSelector:@selector(tapitInterstitialAdActionDidFinish:)]) {
            shouldLoad = [self.tapitDelegate tapitInterstitialAdActionShouldBegin:nil willLeaveApplication:NO]; //TODO pass an accurate "willLeaveApplication" value
        }
    }
    if (shouldLoad) {
        [self openURLInFullscreenBrowser:request.URL];
    }
    else {
        [self dismissModalViewControllerAnimated:self.animated];
    }
    return NO;
}



- (void)dealloc
{
    self.adView = nil;
    self.closeButton = nil;
    self.tappedURL = nil;
    self.tapitDelegate = nil;
    [super dealloc];
}

@end
