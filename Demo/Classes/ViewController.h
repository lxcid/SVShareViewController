//
//  SVShareViewController Demo Project
//	ViewController.h
//
//  Created by Sam Vermette on 16.04.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SVShareViewController.h"

@interface ViewController : UIViewController <SVShareViewControllerDelegate> {

}

- (IBAction)shareOnFacebook;
- (IBAction)shareOnTwitter;

@end

