//
//  TapItAdBrowserController.h
//  TapItAdMobile
//
//  Based on MPAdBrowserController by MoPub
//
//  Copyright 2012 TapIt, Inc. All rights reserved.
//

#import "TapItAdBrowserController.h"

@interface TapItAdBrowserController ()
@property (nonatomic, retain) UIActionSheet *actionSheet;
- (void)dismissActionSheet;
- (void)processTapItClickTrackingRedirect:(NSURL *)tapitURL;
@end

@implementation TapItAdBrowserController

@synthesize webView = _webView;
@synthesize backButton = _backButton;
@synthesize forwardButton = _forwardButton;
@synthesize refreshButton = _refreshButton;
@synthesize safariButton = _safariButton;
@synthesize doneButton = _doneButton;
@synthesize spinnerItem = _spinnerItem;
@synthesize actionSheet = _actionSheet;
@synthesize delegate = _delegate;
@synthesize URL = _URL;

static NSArray *BROWSER_SCHEMES, *SPECIAL_HOSTS;

+ (void)initialize 
{
	// Schemes that should be handled by the in-app browser.
	BROWSER_SCHEMES = [[NSArray arrayWithObjects:
						@"http",
						@"https",
						nil] retain];
	
	// Hosts that should be handled by the OS.
	SPECIAL_HOSTS = [[NSArray arrayWithObjects:
					  @"phobos.apple.com",
					  @"maps.google.com",
					  nil] retain];
}

#pragma mark -
#pragma mark Lifecycle

- (id)initWithURL:(NSURL *)URL delegate:(id<TapItAdBrowserControllerDelegate>)delegate
{
	if (self = [super initWithNibName:@"TapItAdBrowserController" bundle:nil])
	{
		_delegate = delegate;
		_URL = [URL copy];
//        NSLog(@"Loading url in internal browser: %@", _URL);
		
		_webView = [[UIWebView alloc] initWithFrame:CGRectZero];
		_webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | 
		UIViewAutoresizingFlexibleHeight;
		_webView.delegate = self;
		_webView.scalesPageToFit = YES;
		
		_spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
		[_spinner sizeToFit];
		_spinner.hidesWhenStopped = YES;

//        [self processTapItClickTrackingRedirect:_URL];
	}
	return self;
}


- (void)dealloc
{
	_delegate = nil;
	_webView.delegate = nil;
	[_webView release];
	[_URL release];
	[_backButton release];
	[_forwardButton release];
	[_refreshButton release];
	[_safariButton release];
	[_doneButton release];
	[_spinner release];
	[_spinnerItem release];
	[_actionSheet release];
	[super dealloc];
}

- (void)viewDidLoad{
	[super viewDidLoad];
	
	// Set up toolbar buttons
	self.backButton.image = [self backArrowImage];
	self.backButton.title = nil;
	self.forwardButton.image = [self forwardArrowImage];
	self.forwardButton.title = nil;
	self.spinnerItem.customView = _spinner;	
	self.spinnerItem.title = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	// Set button enabled status.
	_backButton.enabled = _webView.canGoBack;
	_forwardButton.enabled = _webView.canGoForward;
	_refreshButton.enabled = NO;
	_safariButton.enabled = NO;
	
    // content will be loaded once the tapit link tracker redirect occurs...
    [_webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
}

#pragma mark -
#pragma mark Navigation

- (IBAction)refresh 
{
	[self dismissActionSheet];
	[_webView reload];
}

- (IBAction)done 
{
	[self dismissActionSheet];
	[self.delegate dismissBrowserController:self];
}

- (IBAction)back 
{
	[self dismissActionSheet];
	[_webView goBack];
	_backButton.enabled = _webView.canGoBack;
	_forwardButton.enabled = _webView.canGoForward;
}

- (IBAction)forward 
{
	[self dismissActionSheet];
	[_webView goForward];
	_backButton.enabled = _webView.canGoBack;
	_forwardButton.enabled = _webView.canGoForward;
}

- (IBAction)safari
{
	if (_actionSheetIsShowing)
	{
		[self dismissActionSheet];
	}
	else 
	{
		self.actionSheet = [[[UIActionSheet alloc] initWithTitle:nil
													   delegate:self 
											  cancelButtonTitle:@"Cancel" 
										 destructiveButtonTitle:nil 
											  otherButtonTitles:@"Open in Safari", nil] autorelease];
		[self.actionSheet showFromBarButtonItem:self.safariButton animated:YES];
	}
}	

- (void)dismissActionSheet
{
	[self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{	
	if (buttonIndex == 0) 
	{
		// Open in Safari.
		[[UIApplication sharedApplication] openURL:_webView.request.URL];
        [self.delegate dismissBrowserController:self]; //TODO notify delegate that we're leaving the app
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	_actionSheetIsShowing = NO;
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
	_actionSheetIsShowing = YES;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType 
{
//    NSLog(@"AdBrowser->webView:shouldStartLoadWithRequest: %@ (%d)", request, navigationType);
	
	/* 
	 * For all links with http:// or https:// scheme, open in our browser UNLESS
	 * the host is one of our special hosts that should be handled by the OS.
	 */
	if ([BROWSER_SCHEMES containsObject:request.URL.scheme])
	{
		if ([SPECIAL_HOSTS containsObject:request.URL.host])
		{
//			[self.delegate dismissBrowserController:self animated:NO];
			[[UIApplication sharedApplication] openURL:request.URL];
//            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
            [self.delegate dismissBrowserController:self];
			return NO;
		}
		else 
		{
			return YES;
		}
	}
	// Non-http(s):// scheme, so ask the OS if it can handle.
	else 
	{
		if ([[UIApplication sharedApplication] canOpenURL:request.URL])
		{
//			[self.delegate dismissBrowserController:self animated:NO]; 
			[[UIApplication sharedApplication] openURL:request.URL];
//            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
            [self.delegate dismissBrowserController:self];
			return NO;
		}
	}
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView 
{
//    NSLog(@"AdBrowser->webViewDidFinishLoad");
	_refreshButton.enabled = YES;
	_safariButton.enabled = YES;
	[_spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
//    NSLog(@"AdBrowser->webViewDidFinishLoad");
	_refreshButton.enabled = YES;
	_safariButton.enabled = YES;	
	_backButton.enabled = _webView.canGoBack;
	_forwardButton.enabled = _webView.canGoForward;
	[_spinner stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
//    NSLog(@"AdBrowser->webView:didFailLoadWithError: %@", error);
    // Ignore NSURLErrorDomain error -999.
    if (error.code == NSURLErrorCancelled) return;
    
    // Ignore "Fame Load Interrupted" errors. Seen after app store links.
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) return;
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(dismissBrowserController:animated:)]) {
            [self.delegate dismissBrowserController:self animated:NO];
        }
    }
//	[self webViewDidFinishLoad:webView];
}



#pragma mark -
#pragma mark TapIt click tracking redirect code

- (void)processTapItClickTrackingRedirect:(NSURL *)tapitURL
{
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:tapitURL] delegate:self startImmediately:YES];
    [con release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSURL *responseURL = [response URL];
    
    if(![responseURL.host hasSuffix:@"c.tapit.com"])
    {
        // not the tracking url, fire the webview request
        self.URL = responseURL;
        NSLog(@"CANCEL!!!");
        [connection cancel];
        [_webView loadRequest:[NSURLRequest requestWithURL:self.URL]];    
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"No more redirects: %@", connection);
}


#pragma mark -
#pragma mark Drawing

- (CGContextRef)createContext
{
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(nil,27,27,8,0,
												 colorSpace,kCGImageAlphaPremultipliedLast);
	CFRelease(colorSpace);
	return context;
}

- (UIImage *)backArrowImage
{
	CGContextRef context = [self createContext];
	CGColorRef fillColor = [[UIColor blackColor] CGColor];
	CGContextSetFillColor(context, CGColorGetComponents(fillColor));
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 8.0f, 13.0f);
	CGContextAddLineToPoint(context, 24.0f, 4.0f);
	CGContextAddLineToPoint(context, 24.0f, 22.0f);
	CGContextClosePath(context);
	CGContextFillPath(context);
	
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
	CGImageRelease(imageRef);
	return [image autorelease];
}

- (UIImage *)forwardArrowImage
{
	CGContextRef context = [self createContext];
	CGColorRef fillColor = [[UIColor blackColor] CGColor];
	CGContextSetFillColor(context, CGColorGetComponents(fillColor));
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 24.0f, 13.0f);
	CGContextAddLineToPoint(context, 8.0f, 4.0f);
	CGContextAddLineToPoint(context, 8.0f, 22.0f);
	CGContextClosePath(context);
	CGContextFillPath(context);
	
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
	CGImageRelease(imageRef);
	return [image autorelease];
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
