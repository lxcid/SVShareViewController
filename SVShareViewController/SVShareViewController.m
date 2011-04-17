//
//  SVShareViewController.m
//
//  Created by Sam Vermette on 17.04.11.
//  Copyright 2010 Sam Vermette. All rights reserved.
//

#import "SVShareViewController.h"

#define kSWNavTintFacebook [UIColor colorWithRed:0.108 green:0.323 blue:0.552 alpha:1.000]
#define kSWNavTintTwitter [UIColor colorWithRed:0.179 green:0.591 blue:0.728 alpha:1.000]

@interface SVShareViewController ()

@property (readwrite) SVShareType shareType;
@property (readwrite) BOOL disableKeyboard;

- (void)updateCharCount;

@end

@implementation SVShareViewController

@synthesize userString, defaultMessage;
@synthesize delegate, shareType, disableKeyboard;

#pragma mark -
#pragma mark View Life Cycle


- (void)dealloc {
    [super dealloc];
}


- (SVShareViewController*)initWithShareType:(SVShareType)sType {
	
	if(self = [super initWithNibName:@"SVShareViewController" bundle:[NSBundle mainBundle]]) {
		self.shareType = sType;
		logoView.hidden = YES;
		
		if(shareType == SVShareTypeFacebook && self.view) {
			navBar.tintColor = toolbar.tintColor = kSWNavTintFacebook;
			logoView.image = [UIImage imageNamed:@"facebookLogo.png"];
			charLabel.hidden = YES;
		}
		
		else if(self.view) {
			navBar.tintColor = toolbar.tintColor = kSWNavTintTwitter;
			logoView.image = [UIImage imageNamed:@"twitterLogo.png"];
			charLabel.hidden = NO;
			[self updateCharCount];
		}
		
		[rTextView becomeFirstResponder];
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
//	CALayer *dummyLine = [CALayer layer];
//	dummyLine.frame = CGRectMake(0,1,320,1);
//	dummyLine.backgroundColor = [[UIColor colorWithWhite:1 alpha:0.42] CGColor];
//	[toolbar.layer addSublayer:dummyLine];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark UI Setters

- (void)setUserString:(NSString *)aString {
	userLabel.text = aString;
}

- (void)setDefaultMessage:(NSString *)aString {
	rTextView.text = aString;
}

#pragma mark -
#pragma mark Actions

- (void)dismiss {
	disableKeyboard = NO;
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}


- (void)logout {
	NSString *service;
	
	if(self.shareType == SVShareTypeFacebook)
		service = @"Facebook";
	else
		service = @"Twitter";
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Logout %@", service] 
														message:[NSString stringWithFormat:@"Are you sure you want to logout from %@?", service] 
													   delegate:self 
											  cancelButtonTitle:@"Cancel" 
											  otherButtonTitles:@"Logout", nil];
	
	[alertView show];
	[alertView release];
}


#pragma mark -
#pragma mark UIAlertViewDelegate (for logout action)

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	if(buttonIndex == 1)
		[delegate shareViewController:self logoutFromService:self.shareType];
}



#pragma mark -
#pragma mark UITextView Delegate methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	if(disableKeyboard)
		return NO;
	
	if([text isEqualToString:@"\n"]) {
		[delegate shareViewController:self sendMessage:textView.text forService:self.shareType];
		return NO;
	}
	
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
	
	[self updateCharCount];
}
			 
			 
			 
- (void)updateCharCount {
	
	charLabel.text = [NSString stringWithFormat:@"%i", 140-[rTextView.text length]];;
}


#pragma mark -
#pragma mark Memory Methods


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



@end
