//
//  Found.m
//  EyesEverywhere
//
//  Created by Tom on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Found.h"
#import "AppDelegate.h"
#import "Reachability.h"

@implementation Found {
    NSString *rd;
}

@synthesize RNDer,CDesc;
@synthesize activityView;
@synthesize photoButton, backButton;

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
    
    [backButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];

    
    CDesc.text = @"Spotted Description: Please inform everyone where you spotted the request and any other information that may have been wanted!";
    CDesc.textColor = [UIColor lightGrayColor];
    
    // Do any additional setup after loading the view from its nib.
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];


}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];

    if ([[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] == ReachableViaWiFi) {
        // Do something that requires wifi
    } else if ([[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] == ReachableViaWWAN) {
        // Do something that doesnt require wifi
    } else if ([[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] == NotReachable) {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"No Internet Connection!" message:@"Sorry, but no internet connectivity was found. EyesEverywhere needs an internet connection in order for you to request! Please connect to wifi or data source such as 3G/4G." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];    
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    CDesc.text = @"";
    imageCView.image = nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return (interfaceOrientation == UIInterfaceOrientationPortrait); 
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([CDesc.text isEqualToString:@"Spotted Description: Please inform everyone where you spotted the request and any other information that may have been wanted!"]) {
        CDesc.text = @"";
        CDesc.textColor = [UIColor blackColor];
    }
    [CDesc becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([CDesc.text isEqualToString:@""]) {
        CDesc.text = @"Spotted Description: Please inform everyone where you spotted the request and any other information that may have been wanted!";
        CDesc.textColor = [UIColor lightGrayColor];
    }
    [CDesc resignFirstResponder];
}

-(IBAction)pushPick:(id)sender {
    /* old way
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:picker animated:YES];
    */
    
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

-(void)takePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:picker animated:YES];
    
}

-(void)libr {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:picker animated:YES];
}

- (void)loadImage {
    
    NSString *imageLoc;


        if (imageCView.image != nil) {
    // change compression rate
    UIImage *toNSData;
    toNSData = [self scaleAndRotateImage:imageCView.image];
    
    NSData *imageData = UIImageJPEGRepresentation(toNSData, 0.2);
    NSString *urlString = [NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/upload2341upload/uploadC.php?RND=%@", RNDer];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
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
    
    
    imageLoc = [NSString stringWithFormat:@"%@%@/%@",headerIMG, RNDer,returnString];
            
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
    
    //Begin Push to SQL -- use RNDer to prober RND table
    
    rd = [rd stringByReplacingOccurrencesOfString:@" " withString:@"%20"
                                          options:NSRegularExpressionSearch
                                            range:NSMakeRange(0, rd.length)];
    rd = [rd stringByReplacingOccurrencesOfString:@"\n" withString:@"R8D5"
                                          options:NSRegularExpressionSearch
                                            range:NSMakeRange(0, rd.length)];
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/p1h6p5/HiTrEqUeSt.php?RND=%@&username=%@&Cdesc=%@&imgloc=%@&time=%@",RNDer,appDelegate.userName, rd, imageLoc, currenttime]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSData *urlData;
    NSURLResponse *response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    
    // urlData receives the returned information and then you can process
    // it by storing in a temporary file and working with NSStrings  
    
    
    [self performSelectorOnMainThread:@selector(displayImage) withObject:nil waitUntilDone:NO];

}

- (void)displayImage {
    //stop network spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //stop activity bar
    [activityView stopAnimating];
    
    // alert success on submitting
    UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Congrats" message:@"Thank you for your submittion" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertsuccess show];
}

- (IBAction)pushUpload:(id)sender {
    // Below Uploads the Rtitle, CDesc, PhotoLocation(imageLoc), and GPScoords?
    
    if (![self.CDesc.text isEqualToString:@""] && ![self.CDesc.text isEqualToString:@"Spotted Description: Please inform everyone where you spotted the request and any other information that may have been wanted!"]) 
    {
        
        activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake(0, 0, 40.0, 40.0);
        activityView.center = self.view.center;
        [self.view addSubview: activityView];
        
        //start network spinner
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [activityView startAnimating];
        rd = CDesc.text;
        
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
                                            initWithTarget:self
                                            selector:@selector(loadImage) 
                                            object:nil];
        [queue addOperation:operation]; 
    
        
        CDesc.text = @"";
        //imageCView.image = nil;
        
        //change button image
        UIImage *btnImage = [UIImage imageNamed:@"Requests_PhotoButton.png"];
        [photoButton setImage:btnImage forState:UIControlStateNormal];

        
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
        
	imageCView.image = image;
    
    //change button image
    UIImage *btnImage = [UIImage imageNamed:@"Requests_PhotoButton_Clipped.png"];
    [photoButton setImage:btnImage forState:UIControlStateNormal];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker.parentViewController dismissModalViewControllerAnimated:YES];
}

-(IBAction)backgroundClick:(id)sender
{
    [CDesc resignFirstResponder];
}


- (IBAction)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];  
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
