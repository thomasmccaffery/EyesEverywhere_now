//
//  NewRequests.m
//  EyesEverywhere
//
//  Created by Tom on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewRequests.h"
#import "AppDelegate.h"
#import "Reachability.h"

// ADD A SPINNER SOMEHOW TO SHOW LOADING upload
// FIND A WAY TO RESET REQUESTS WHEN CLICKED AGAIN!

@implementation NewRequests {
    NSString *Rtit;
    NSString *Rdes;
    int checking;
}

@synthesize RTitle;
@synthesize RDesc;
@synthesize locationManager;
@synthesize activityView;
@synthesize photoButton;
@synthesize warning;

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
    
    [self.RTitle setReturnKeyType:UIReturnKeyDone];
    [self.RTitle addTarget:self
                           action:@selector(textFieldFinished:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];

    RDesc.text = @"Request Description: Type out your request in pain-steaking details here for everyone else to get a better vision of what you are looking for!";
    RDesc.textColor = [UIColor lightGrayColor];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    RTitle.text = @"";
    RDesc.text = @"";
    imageView.image = nil;
    // Release any retained subviews of the main view.
}


- (void) viewWillAppear:(BOOL)animated {
    
    if ([[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] == ReachableViaWiFi) {
        // Do something that requires wifi
    } else if ([[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] == ReachableViaWWAN) {
        // Do something that doesnt require wifi
    } else if ([[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] == NotReachable) {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"No Internet Connection!" message:@"Sorry, but no internet connectivity was found. EyesEverywhere needs an internet connection in order for you to request! Please connect to wifi or data source such as 3G/4G." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];    
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // check if proper amount of requests
    NSString *hostStr =[NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/ReQcHeCk.php?username=%@",appDelegate.userName];        
    
    // make a new SQL and PHP for this iphonereg!
    NSData *dataURL =  [NSData dataWithContentsOfURL: [ NSURL URLWithString: hostStr ]];    
    NSString *serverOutput = [[NSString alloc] initWithData:dataURL encoding: NSASCIIStringEncoding];
    NSString *trimmedString = [serverOutput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    checking = [trimmedString intValue];
    
    if (checking <= 0) 
    {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Out of Requests!" message:@"Sorry, but you've used up your 5 free weekly requests! To request more this week, please go into the Portfolio tab and purchase more requests." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
        
        warning.hidden = NO;
        
    } else if (checking > 0) {
        warning.hidden = YES;

    } else {
        UIAlertView *alertCON = [[UIAlertView alloc] initWithTitle:@"Connection Error:" message:@"There was an error connecting to the internet! Please try checking if you're connected and then reload the tab!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertCON show];    }

}
 

- (void) viewDidAppear:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    

}

-(void) viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

}


-(IBAction)backgroundClick:(id)sender
{
    [RTitle resignFirstResponder];
    [RDesc resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([RDesc.text isEqualToString:@"Request Description: Type out your request in pain-steaking details here for everyone else to get a better vision of what you are looking for!"]) {
        RDesc.text = @"";
        RDesc.textColor = [UIColor blackColor];
    }
    [RDesc becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([RDesc.text isEqualToString:@""]) {
        RDesc.text = @"Request Description: Type out your request in pain-steaking details here for everyone else to get a better vision of what you are looking for!";
        RDesc.textColor = [UIColor lightGrayColor];
    }
    [RDesc resignFirstResponder];
}

-(IBAction)pushPick:(id)sender {
        
    [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Close" destructiveButtonTitle:nil otherButtonTitles:@"Snap Photo", @"Photo Library", nil] showInView:[self.view window]];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self takePhoto]; break;
        case 1:
            [self libr];break;
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:NO];
}

-(void)takePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:picker animated:YES];
	[picker release];
    
}

-(void)libr {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:picker animated:YES];
	[picker release];
}



- (void)loadDat {
    //do process
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}


- (IBAction)pushUpload:(id)sender {
    
    locationManager.delegate = self;
    
    // Below Uploads the Rtitle, Rdesc, PhotoLocation(imageLoc), and GPScoords?
    
   if (![self.RTitle.text isEqualToString:@""] && ![self.RDesc.text isEqualToString:@""] && ![self.RDesc.text isEqualToString:@"Request Description: Type out your request in pain-steaking details here for everyone else to get a better vision of what you are looking for!"]) 
    {
        
        activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake(0, 0, 40.0, 40.0);
        activityView.center = self.view.center;
        [self.view addSubview: activityView];
        
        //start network spinner
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [activityView startAnimating];
        Rtit = RTitle.text;
        Rdes = RDesc.text;
        
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
                                            initWithTarget:self
                                            selector:@selector(loadDat) 
                                            object:nil];
        [queue addOperation:operation]; 
                
    }
    else 
    {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill out all forms and try again!"
                                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
    }
    
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
	[picker.parentViewController dismissModalViewControllerAnimated:YES];
	imageView.image = image;
    
    //change button image
    UIImage *btnImage = [UIImage imageNamed:@"Requests_PhotoButton_Clipped.png"];
    [photoButton setImage:btnImage forState:UIControlStateNormal];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return (interfaceOrientation == UIInterfaceOrientationPortrait); 
}

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation{
    
    [locationManager stopUpdatingLocation];
    [manager stopUpdatingLocation];
    
    NSString *latt = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
	NSString *lonn = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    
    NSString *imageLoc;
    
    if (imageView.image != nil) {
        
    
    // start push iamge
        UIImage *toNSData;
        toNSData = [self scaleAndRotateImage:imageView.image];
        NSData *imageData = UIImageJPEGRepresentation(toNSData, 0.25);
    NSString *urlString = @"http://thefourthc.info/EyesEverywhere/upload2341upload/upload.php";
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];

    NSString *headerIMG = @"thefourthc.info/EyesEverywhere/upload2341upload/";
    
    imageLoc = [NSString stringWithFormat:@"%@%@",headerIMG,returnString];
        
    } else {
        imageLoc = @"none";
    }
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];    
    
    //Get current time
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //get the date today
    
    
    NSString *dateToday = [formatter stringFromDate:[NSDate date]];
    
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"EEEE"];
    
    NSString *currenttime = [NSString stringWithFormat:@"(%@)",dateToday];
    
    //Begin Push to SQL
    
    NSString *Rtitle = [NSString stringWithFormat:@"%@", RTitle.text];        
    Rtitle = [Rtitle stringByReplacingOccurrencesOfString:@" " withString:@"%20"
                                                  options:NSRegularExpressionSearch
                                                    range:NSMakeRange(0, Rtitle.length)];
    NSString *rd = RDesc.text;
    rd = [rd stringByReplacingOccurrencesOfString:@" " withString:@"%20"
                                          options:NSRegularExpressionSearch
                                            range:NSMakeRange(0, rd.length)];
    rd = [rd stringByReplacingOccurrencesOfString:@"\n" withString:@"R8D5"
                                          options:NSRegularExpressionSearch
                                            range:NSMakeRange(0, rd.length)];

    locationManager.delegate = nil;

    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/p1h6p5/NeWrEqUeSt.php?username=%@&Rtitle=%@&Rdesc=%@&imgloc=%@&time=%@&lat=%@&lon=%@",appDelegate.userName, Rtitle, rd, imageLoc, currenttime,latt,lonn]];
     
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSData *urlData;
    NSURLResponse *response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    // urlData receives the returned information and then you can process
    // it by storing in a temporary file and working with NSStrings  
    
    /* -- gets echo data from php
    NSString *urlDataa = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    NSLog(@"return log -- %@", urlDataa);
    */
    
    // alert success on submitting
    UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Congrats" message:@"Thank you for your submittion" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertsuccess show];
    
    
    checking = checking - 1;
    
    if (checking <= 0) 
    {
        warning.hidden = NO;
        
    } else if (checking > 0) {
        warning.hidden = YES;
    } 
     

    
    RTitle.text = @"";
    RDesc.text = @"";
    imageView.image = nil;
    
    //change button image
    UIImage *btnImage = [UIImage imageNamed:@"Requests_PhotoButton.png"];
    [photoButton setImage:btnImage forState:UIControlStateNormal];

    
    //stop network spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    

     //stop activity bar
     [activityView stopAnimating];


}


//fix rotate
- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}



@end
