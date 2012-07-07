//
//  TapItInterstitialAdViewController.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TapItInterstitialAdViewController.h"
#import "TapItAdBrowserController.h"
#import "TapItAdView.h"

@interface TapItInterstitialAdViewController ()

@end

@implementation TapItInterstitialAdViewController
@synthesize animated, adView, tapitDelegate;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


#pragma mark -
#pragma mark Orientation code

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self repositionToInterfaceOrientation:toInterfaceOrientation];
}

- (void)repositionToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        // swap width <--> height
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    
    CGFloat x = 0, y = 0;
    CGFloat w = self.adView.frame.size.width, h = self.adView.frame.size.height;
    
    x = size.width/2 - self.adView.frame.size.width/2;
    y = size.height/2 - self.adView.frame.size.height/2;
    
    self.adView.center = self.view.center;
    
    if(self.animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.adView setFrame:CGRectMake(x, y, w, h)];
        }
                         completion:^(BOOL finished){}
         ];
    }
    else {
        [self.adView setFrame:CGRectMake(x, y, w, h)];
    }
}

#pragma mark -
#pragma mark TapItAdBrowserController methods

- (void)openURLInFullscreenBrowser:(NSURL *)url {
    BOOL shouldLoad = [self.tapitDelegate tapitInterstitialAdActionShouldBegin:nil willLeaveApplication:NO];
    if (!shouldLoad) {
        id<TapItInterstitialAdDelegate> tDel = [self.tapitDelegate retain];
        [self dismissViewControllerAnimated:self.animated completion:^{
            [tDel tapitInterstitialAdDidUnload:nil];
            [tDel release];
        }];
        return;
    }
    
    // Present ad browser.
    TapItAdBrowserController *browserController = [[TapItAdBrowserController alloc] initWithURL:url delegate:self];
    [self presentModalViewController:browserController animated:self.animated];
    [browserController release];
}

- (void)dismissBrowserController:(TapItAdBrowserController *)browserController {
    id<TapItInterstitialAdDelegate> tDel = [self.tapitDelegate retain];
    [self dismissBrowserController:browserController animated:self.animated];
    [tDel tapitInterstitialAdDidUnload:nil];
    [tDel release];
}

- (void)dismissBrowserController:(TapItAdBrowserController *)browserController animated:(BOOL)isAnimated {
    id<TapItInterstitialAdDelegate> tDel = [self.tapitDelegate retain];
    [self.presentingViewController dismissViewControllerAnimated:self.animated completion:^{
        [tDel tapitInterstitialAdActionDidFinish:nil];
        [tDel release];
    }];
}

@end
