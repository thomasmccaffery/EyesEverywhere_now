//
//  ViewController.h
//  EyesEverywhere
//
//  Created by Tom on 8/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    
    //activity indictator
    UIActivityIndicatorView * activityView;

}

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;

-(IBAction)loginButton:(id)sender;
-(IBAction)registerButton:(id)sender;

//activity indicator
@property(nonatomic,retain)  UIActivityIndicatorView * activityView;
- (void)threadStartAnimating:(id)data;


@end
