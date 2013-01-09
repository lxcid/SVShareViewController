//
//  SVShareViewController.h
//
//  Created by Sam Vermette on 17.04.11.
//  Copyright 2010 Sam Vermette. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SVShareType) {
    SVShareTypeFacebook,
	SVShareTypeTwitter
};

@protocol SVShareViewControllerDelegate;

@interface SVShareViewController : UIViewController <UIAlertViewDelegate, UITextViewDelegate>;

@property (nonatomic, strong) IBOutlet UITextView *rTextView;
@property (nonatomic, strong) IBOutlet UINavigationBar *navBar;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet UIImageView *logoView;
@property (nonatomic, strong) IBOutlet UILabel *charLabel;
@property (nonatomic, strong) IBOutlet UILabel *userLabel;

@property (nonatomic, assign) id<SVShareViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *userString;
@property (nonatomic, copy) NSString *defaultMessage;

- (id)initWithShareType:(SVShareType)sType;

- (IBAction)dismiss;

@end


@protocol SVShareViewControllerDelegate

- (void)shareViewControllerDidFinish:(SVShareViewController *)controller;
- (void)shareViewController:(SVShareViewController*)controller sendMessage:(NSString*)string forService:(SVShareType)shareType;

@end
