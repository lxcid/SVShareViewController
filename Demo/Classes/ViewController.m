//
//  SVShareViewControllerViewController.m
//  SVShareViewController
//
//  Created by Sam Vermette on 16.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

#pragma mark -

- (void)shareOnFacebook {
	
	SVShareViewController *fbViewController = [[SVShareViewController alloc] initWithShareType:SVShareTypeFacebook];
	fbViewController.delegate = self;
	fbViewController.userString = @"John Smith";
	fbViewController.defaultMessage = @"User the .defaultMessage property to prefill this field with a stock message.";
	
	[self presentModalViewController:fbViewController animated:YES];
	[fbViewController release];
}

- (void)shareOnTwitter {
	
	SVShareViewController *twViewController = [[SVShareViewController alloc] initWithShareType:SVShareTypeTwitter];
	twViewController.delegate = self;
	twViewController.userString = @"@johnsmith";
	twViewController.defaultMessage = @"User the .defaultMessage property to prefill this field with a stock message.";
	
	[self presentModalViewController:twViewController animated:YES];
	[twViewController release];
}

#pragma mark -
#pragma mark SVShareViewControllerDelegate

- (void)shareViewController:(SVShareViewController*)controller sendMessage:(NSString*)string forService:(SVShareType)shareType {
	
	// use MGTwitterEngine or Facebook iOS SDK to send message
	
	// it's a good idea to display a progress HUD to let the user know what's going on
	// you might want to have a look at SVProgressHUD: https://github.com/samvermette/SVProgressHUD
	
	[controller dismiss];
}

- (void)shareViewController:(SVShareViewController*)controller logoutFromService:(SVShareType)shareType {
	
	// use MGTwitterEngine or Facebook iOS SDK to logout
	// clear access tokens from NSUserDefaults here
	
	// it's a good idea to display a progress HUD to let the user know what's going on
	// you might want to have a look at SVProgressHUD: https://github.com/samvermette/SVProgressHUD
	
	[controller dismiss];
	
}

#pragma mark -

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end