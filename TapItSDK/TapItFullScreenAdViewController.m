//
//  TapItFullScreenAdViewController.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TapItFullScreenAdViewController.h"
#import "TapItAdView.h"

@interface TapItFullScreenAdViewController ()

@end

@implementation TapItFullScreenAdViewController
@synthesize adView, actionSheet, glassView;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet taped: %d", buttonIndex);
    switch (buttonIndex) {
        case 0:
            // call to action tapped
            ;
            NSString *clickURL = [self.adView.data objectForKey:@"clickurl"];
            NSLog(@"clickURL: %@", clickURL);
            NSURL *url = [NSURL URLWithString:clickURL];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [adView loadRequest:request];
            [self dismissModalViewControllerAnimated:YES];
            break;
        
        case 1:
        default:
            // skip tapped
            [self dismissModalViewControllerAnimated:YES];
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.adView setCenter:self.view.center];
    [self.view addSubview:(UIView *)self.adView];
    self.glassView = [[[UIView alloc] initWithFrame:self.view.frame] autorelease];
    [self.view addSubview:self.glassView];
    self.view.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *singleFingerTap = 
    [[UITapGestureRecognizer alloc] initWithTarget:self 
                                            action:@selector(glassTapped:)];
    [self.glassView addGestureRecognizer:singleFingerTap];
    [singleFingerTap release];

    self.navigationBarHidden = YES;
    NSString *callToAction = (NSString *)[self.adView.data objectForKey:@"calltoaction"];
    if(callToAction == nil) {
        callToAction = @"Get More Info";
    }
    self.actionSheet = [[[UIActionSheet alloc] initWithTitle:nil
                                              delegate:self 
                                     cancelButtonTitle:nil 
                                destructiveButtonTitle:nil 
                                     otherButtonTitles:callToAction, @"Skip", nil] autorelease];
    self.actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
}

- (void)glassTapped:(UITapGestureRecognizer *)recognizer
{
//    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    // user can tap anywhere
    NSLog(@"Glass Tapped!");
    [self.actionSheet showInView:self.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.glassView = nil;
    self.actionSheet = nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    self.adView = nil;
    [super dealloc];
}
@end
