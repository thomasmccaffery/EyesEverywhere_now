//
//  Social.m
//  EyesEverywhere
//
//  Created by Tom on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Social.h"
#import "AppDelegate.h"
#import "Reachability.h"

@implementation Social {
    NSString *rd;
}

@synthesize Form;
@synthesize activityView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:TRUE animated:NO];
    
    scrollView.contentSize = CGSizeMake(320, 800);
    
	[scrollView flashScrollIndicators];

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    if ([[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] == ReachableViaWiFi) {
        // Do something that requires wifi
    } else if ([[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] == ReachableViaWWAN) {
        // Do something that doesnt require wifi
    } else if ([[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] == NotReachable) {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"No Internet Connection!" message:@"Sorry, but no internet connectivity was found. EyesEverywhere needs an internet connection in order for you to submit the form! Please connect to wifi or data source such as 3G/4G." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];    
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    Form.text = @"";
    rd = @"";

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return (interfaceOrientation == UIInterfaceOrientationPortrait); 
}

- (IBAction)submiter:(id)sender {
    //Send form data to server w/ username
    //start network spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //send data
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
                                        initWithTarget:self
                                        selector:@selector(sendData) 
                                        object:nil];
    [queue addOperation:operation]; 

}

-(IBAction)backgroundClick:(id)sender
{
    [Form resignFirstResponder];
}

- (void)sendData {
    
    if (![self.Form.text isEqualToString:@""]) 
    {
     AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate]; 

    // push data to server
    rd = Form.text;
    
    rd = [rd stringByReplacingOccurrencesOfString:@" " withString:@"%20"
                                          options:NSRegularExpressionSearch
                                            range:NSMakeRange(0, rd.length)];
    rd = [rd stringByReplacingOccurrencesOfString:@"\n" withString:@"R8D5"
                                          options:NSRegularExpressionSearch
                                            range:NSMakeRange(0, rd.length)];
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/p1h6p5/FoRmEr.php?username=%@&former=%@",appDelegate.userName, rd]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSData *urlData;
    NSURLResponse *response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];

    // alert success on submitting
    UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Thanks!" message:@"Thank you for your feedback and contributing to the social-evolution! Lets make this network better together!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertsuccess show];
        
    //clear form
    [self performSelectorOnMainThread:@selector(clearer) withObject:nil waitUntilDone:NO];

        
        
    } else {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill out all forms and try again!"
                                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
    }
    
    //stop network spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

-(void)clearer {
    Form.text = @"";
    rd = @"";
}


@end
