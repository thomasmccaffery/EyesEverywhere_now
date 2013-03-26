//
//  RegisterViewController.h
//  EyesEverywhere
//
//  Created by Tom on 8/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface RegisterViewController : UIViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{   
    //input fields
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *emailField;
    IBOutlet UIImageView *profileIm;
    
    //checkbox drawings
    BOOL checkboxSelected;
	IBOutlet UIButton *checkboxButton;
    
    //activity indictator
    UIActivityIndicatorView * activityView;

}

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UIButton *registerButton;

//button senders
-(IBAction)register:(id)sender;
-(IBAction)checkboxButton:(id)sender;
-(IBAction)backButton:(id)sender;
-(IBAction)privacyButton:(id)sender;

// profile image
-(IBAction)profile:(id)sender;
-(void)takePhoto;
-(void)libr;

-(void)reger;

//activity indicator
@property(nonatomic,retain)  UIActivityIndicatorView * activityView;

- (UIImage *)scaleAndRotateImage:(UIImage *)image;


@end
