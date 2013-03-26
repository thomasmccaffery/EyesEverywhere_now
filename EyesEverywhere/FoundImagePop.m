//
//  FoundImagePop.m
//  EyesEverywhere
//
//  Created by Tom on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FoundImagePop.h"

@implementation FoundImagePop

@synthesize requestedImage,loading;
@synthesize activityView;
@synthesize date, user, CCdesc;
@synthesize diction;
@synthesize doneButton;

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

    [doneButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake(0, 0, 40.0, 40.0);
    activityView.center = self.view.center;
    [self.view addSubview: activityView];
    
    
    
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
                                        initWithTarget:self
                                        selector:@selector(loadImage) 
                                        object:nil];
    [queue addOperation:operation]; 
        
    
    NSString *labelText = [NSString stringWithFormat:@"Spotted! : %@", [diction objectForKey:@"Cdesc"]];
    labelText = [labelText stringByReplacingOccurrencesOfString:@"%20" withString:@" "
                                          options:NSRegularExpressionSearch
                                            range:NSMakeRange(0, labelText.length)];
    labelText = [labelText stringByReplacingOccurrencesOfString:@"R8D5" withString:@"\n"
                                          options:NSRegularExpressionSearch
                                            range:NSMakeRange(0, labelText.length)];

    [CCdesc setText:labelText];
    [CCdesc setNumberOfLines:0];
    [CCdesc sizeToFit];
    
    NSString *dat = [NSString stringWithFormat:@"On: %@", [diction objectForKey:@"time"]];
    date.text = dat;

    NSString *author = [NSString stringWithFormat:@"By: %@", [diction objectForKey:@"username"]];
    user.text = author;
    
    
    NSString *chk = @"http://none";
    
    
    if ([requestedImage isEqualToString:chk]) {
        loading.text = @"No Image Uploaded";
    }
    
    // Do any additional setup after loading the view from its nib.
}




- (void)loadImage {
    //pass image url
    
    NSString *urlls = [NSString stringWithFormat:@"%@", [diction objectForKey:@"imglocs"]];
    NSString *httpPrefix = @"http://";
    
    NSString *correctPushURL = [httpPrefix stringByAppendingString:urlls];
            
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:correctPushURL]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    [self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
}

- (void)displayImage:(UIImage *)image {
    [requestImage setImage:image]; //UIImageView
   // requestImage.transform = CGAffineTransformMakeRotation(M_PI_2); 

    //stop network spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //stop activity bar
    [activityView stopAnimating];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
        
    //start network spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //start activity bar
    [activityView startAnimating];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return (interfaceOrientation == UIInterfaceOrientationPortrait); 
}

- (IBAction)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];

}

@end
