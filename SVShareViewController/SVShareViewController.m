//
//  SVShareViewController.m
//
//  Created by Sam Vermette on 17.04.11.
//  Copyright 2010 Sam Vermette. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SVShareViewController.h"

#define kSWNavTintFacebook [UIColor colorWithRed:0.108 green:0.323 blue:0.552 alpha:1.000]
#define kSWNavTintTwitter [UIColor colorWithRed:0.179 green:0.591 blue:0.728 alpha:1.000]

@interface SVShareViewController ()

@property (readwrite) SVShareType shareType;
@property (nonatomic, assign) CGRect keyboardFrameEnd;

- (void)updateCharCount;

@end

@implementation SVShareViewController

@synthesize userString = _userString;
@synthesize defaultMessage = _defaultMessage;

#pragma mark - View Life Cycle

- (id)initWithShareType:(SVShareType)sType {
	self = [super initWithNibName:@"SVShareViewController" bundle:[NSBundle mainBundle]];
	if (self) {
		_shareType = sType;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_userString) {
        self.userLabel.text = _userString;
        _userString = nil;
    }
    
    if (_defaultMessage) {
        self.rTextView.text = _defaultMessage;
        _defaultMessage = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    switch (self.shareType) {
        case SVShareTypeFacebook: {
            self.navBar.tintColor = self.toolbar.tintColor = kSWNavTintFacebook;
            self.logoView.image = [UIImage imageNamed:@"SVShareViewController.bundle/facebookLogo.png"];
            self.charLabel.hidden = YES;
        } break;
        case SVShareTypeTwitter: {
            self.navBar.tintColor = self.toolbar.tintColor = kSWNavTintTwitter;
            self.logoView.image = [UIImage imageNamed:@"SVShareViewController.bundle/twitterLogo.png"];
            self.charLabel.hidden = NO;
            [self updateCharCount];
        } break;
    }
    
    [self registerForKeyboardNotifications];
    [self.rTextView becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self unregisterForKeyboardNotifications];
}

- (void)layoutSubviewsForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            self.toolbar.frame = CGRectMake(0.0f, CGRectGetHeight(self.view.bounds) - CGRectGetWidth(self.keyboardFrameEnd) - CGRectGetHeight(self.toolbar.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.toolbar.frame));
        } break;
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown: {
            self.toolbar.frame = CGRectMake(0.0f, CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.keyboardFrameEnd) - CGRectGetHeight(self.toolbar.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.toolbar.frame));
        } break;
    }
    
    self.rTextView.frame = CGRectMake(0.0f, CGRectGetMaxY(self.navBar.frame), CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.toolbar.frame) - CGRectGetMaxY(self.navBar.frame));
    self.charLabel.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - (CGRectGetWidth(self.view.bounds) - CGRectGetMinX(self.charLabel.frame)), CGRectGetMinY(self.toolbar.frame) + ((CGRectGetHeight(self.toolbar.frame) - CGRectGetHeight(self.charLabel.frame)) / 2.0f), CGRectGetWidth(self.charLabel.frame), CGRectGetHeight(self.charLabel.frame));
    self.userLabel.frame = CGRectMake(10.0f, CGRectGetMinY(self.toolbar.frame) + ((CGRectGetHeight(self.toolbar.frame) - CGRectGetHeight(self.userLabel.frame)) / 2.0f), CGRectGetWidth(self.userLabel.frame), CGRectGetHeight(self.userLabel.frame));
}


#pragma mark - Keyboard

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)unregisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillBeShown:(NSNotification *)theNotification {
    NSValue *theValue = theNotification.userInfo[UIKeyboardFrameEndUserInfoKey];
    self.keyboardFrameEnd = theValue.CGRectValue;
    [self layoutSubviewsForInterfaceOrientation:self.interfaceOrientation];
}

- (void)keyboardWillBeHidden:(NSNotification *)theNotification {
    self.keyboardFrameEnd = CGRectZero;
}


#pragma mark - UI Setters

- (void)setUserString:(NSString *)aString {
    if (self.isViewLoaded) {
        self.userLabel.text = [aString copy];
    } else {
        _userString = [aString copy];
    }
}

- (NSString *)userString {
    if (self.isViewLoaded) {
        return self.userLabel.text;
    } else {
        return _userString;
    }
}

- (void)setDefaultMessage:(NSString *)aString {
	if (self.isViewLoaded) {
        self.rTextView.text = aString;
        [self textViewDidChange:self.rTextView];
    } else {
        _defaultMessage = [aString copy];
    }
}

- (NSString *)defaultMessage {
    if (self.isViewLoaded) {
        return self.rTextView.text;
    } else {
        return _defaultMessage;
    }
}


#pragma mark - Actions

- (IBAction)dismiss {
	[self.delegate shareViewControllerDidFinish:self];
}


#pragma mark - UITextView Delegate methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if([text isEqualToString:@"\n"]) {
		[self.delegate shareViewController:self sendMessage:textView.text forService:self.shareType];
		return NO;
	}
	
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
	[self updateCharCount];
}

- (void)updateCharCount {
	self.charLabel.text = [NSString stringWithFormat:@"%i", 140-[self.rTextView.text length]];;
}


#pragma mark - Memory Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
