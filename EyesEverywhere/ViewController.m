//
//  ViewController.m
//  EyesEverywhere
//
//  Created by Tom on 8/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "NSString+MD5.h"

#import "BaseViewController.h"

@implementation ViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize activityView;

-(IBAction)backgroundClick:(id)sender
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}


-(IBAction)loginButton:(id)sender {
    
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@",usernameField.text, [passwordField.text MD5]];
    
    NSString *hostStr = @"http://thefourthc.info/EyesEverywhere/iphonelogin.php?";
    hostStr = [hostStr stringByAppendingString:post];
    NSData *dataURL =  [NSData dataWithContentsOfURL: [ NSURL URLWithString: hostStr ]];    
    NSString *serverOutput = [[NSString alloc] initWithData:dataURL encoding: NSASCIIStringEncoding];
    NSString *trimmedString = [serverOutput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.userName = [NSString stringWithFormat:@"%@",usernameField.text]; 
    
    if([trimmedString isEqualToString:@"Yes"]){
        
        BaseViewController *Base = [[BaseViewController alloc] initWithNibName:nil bundle:nil];
        [self presentModalViewController:Base animated:YES];
    } 
    else if([trimmedString isEqualToString:@"No"]) {
        
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username or Password Incorrect"
                                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];

    }
    else {
        
        UIAlertView *alertCON = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Cannot connect to server, please try connection to the internet or trying again!"
                                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertCON show];
    }
    
    //stop network spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //stop activity bar
    [activityView stopAnimating];
    
    // end activity spinner/bar
}


-(IBAction)registerButton:(id)sender {
    RegisterViewController *Register = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
    [self presentModalViewController:Register animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];

    
    [self.usernameField setReturnKeyType:UIReturnKeyDone];
    [self.usernameField addTarget:self
                           action:@selector(textFieldFinished:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.passwordField setReturnKeyType:UIReturnKeyDone];
    [self.passwordField addTarget:self
                           action:@selector(textFieldFinished:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordField addTarget:self
                           action:@selector(loginButton:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    passwordField.secureTextEntry = YES;
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    usernameField.text = @"";
    passwordField.text = @"";
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait); 
}

- (void) threadStartAnimating:(id)data {
    
    //// start activity indicator
    activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake(0, 0, 30.0, 30.0);
    activityView.backgroundColor = [UIColor lightGrayColor];
    activityView.center = self.view.center;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [self.view addSubview: activityView];
    
    [activityView startAnimating];
    
    //end activity indicator
}


@end
