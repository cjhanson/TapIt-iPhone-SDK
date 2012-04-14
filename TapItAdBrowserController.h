//
//  TapItAdBrowserController.h
//  TapItAdMobile
//
//  Based on MPAdBrowserController by MoPub
//
//  Copyright 2012 TapIt, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef CF_RETURNS_RETAINED
#if __has_feature(attribute_cf_returns_retained)
#define CF_RETURNS_RETAINED __attribute__((cf_returns_retained))
#else
#define CF_RETURNS_RETAINED
#endif
#endif

@protocol TapItAdBrowserControllerDelegate;

@interface TapItAdBrowserController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>
{
	id<TapItAdBrowserControllerDelegate> _delegate;
	UIWebView *_webView;
	UIBarButtonItem *_backButton;
	UIBarButtonItem *_forwardButton;
	UIBarButtonItem *_refreshButton;
	UIBarButtonItem *_safariButton;
	UIBarButtonItem *_doneButton;
	UIActivityIndicatorView *_spinner;
	UIBarButtonItem *_spinnerItem;
	UIActionSheet *_actionSheet;
	BOOL _actionSheetIsShowing;
	NSURL *_URL;
}

@property (nonatomic,retain) IBOutlet UIWebView *webView;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *safariButton;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *spinnerItem;

@property (nonatomic, assign) id<TapItAdBrowserControllerDelegate> delegate;
@property (nonatomic, copy) NSURL *URL;


- (id)initWithURL:(NSURL *)URL delegate:(id<TapItAdBrowserControllerDelegate>)delegate;

// Navigation methods.
- (IBAction)back;
- (IBAction)forward;
- (IBAction)refresh;
- (IBAction)safari;
- (IBAction)done;

// Drawing methods.
- (CGContextRef)createContext CF_RETURNS_RETAINED;
- (UIImage *)backArrowImage;
- (UIImage *)forwardArrowImage;


@end

@protocol TapItAdBrowserControllerDelegate <NSObject>
@required
- (void)dismissBrowserController:(TapItAdBrowserController *)browserController;
- (void)dismissBrowserController:(TapItAdBrowserController *)browserController animated:(BOOL)animated;
@end