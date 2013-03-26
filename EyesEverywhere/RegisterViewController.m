//
//  RegisterViewController.m
//  EyesEverywhere
//
//  Created by Tom on 8/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "ViewController.h"
#import "NSString+MD5.h"
#import "AppDelegate.h"
#import "PrivacyViewController.h"
#import "BaseViewController.h"

@implementation RegisterViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize emailField;
@synthesize registerButton;
@synthesize activityView;



-(IBAction)backButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)privacyButton:(id)sender {
    PrivacyViewController *Privacy = [[PrivacyViewController alloc] initWithNibName:nil bundle:nil];
    [self presentModalViewController:Privacy animated:YES];
}

-(IBAction)backgroundClick:(id)sender
{
    // allows keyboard to be removed when done typing
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [emailField resignFirstResponder];
}

- (IBAction)profile:(id)sender
{
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
	[picker.parentViewController dismissModalViewControllerAnimated:YES];
	profileIm.image = image;
}


- (IBAction)register:(id)sender {
    
    // check if textFields aren't empty
    // test to see if forms filled in, if there are spaces if it works!
    if (![self.usernameField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString:@""] && ![self.emailField.text isEqualToString:@""] && (checkboxSelected == 1)) 
    {

        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];

        
        NSString *post =[NSString stringWithFormat:@"username=%@&password=%@&email=%@",usernameField.text, [passwordField.text MD5], emailField.text];        
        
        // make a new SQL and PHP for this iphonereg!
        NSString *hostStr = @"http://thefourthc.info/EyesEverywhere/iphonereg.php?";
        hostStr = [hostStr stringByAppendingString:post];
        NSData *dataURL =  [NSData dataWithContentsOfURL: [ NSURL URLWithString: hostStr ]];    
        NSString *serverOutput = [[NSString alloc] initWithData:dataURL encoding: NSASCIIStringEncoding];
        NSString *trimmedString = [serverOutput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimmedString isEqualToString:@"NON"]) 
        {
            UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Username Already Taken!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertsuccess show];
        }
        else if([trimmedString isEqualToString:@"USE"])
        {
            NSOperationQueue *queue = [NSOperationQueue new];
            NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
                                                initWithTarget:self
                                                selector:@selector(reger) 
                                                object:nil];
            [queue addOperation:operation]; 

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
        
        // end activity spinner/bar -- show alert success
    }
    else if (checkboxSelected == 0)
    {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please accept the terms of use and privacy!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
    }
    /*else if([self.usernameField.text rangeOfString:@" "].location != NSNotFound)
    {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Username Error!" message:@"Usernames cannot contain spaces!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
    }
    else if([self.passwordField.text rangeOfString:@" "].location != NSNotFound)
    {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Password Error!" message:@"Passswords cannot contain spaces!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
    }
    else if([self.emailField.text rangeOfString:@" "].location != NSNotFound)
    {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Email Error!" message:@"Emails cannot contain spaces!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
    }*/
    else 
    {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill out all forms and try again!"
                                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
        
        
    }

}

- (void)reger {
    
    
    // upload image and send to sql
    
    NSString *imageLoc;
    
    // start push image -- to /pro folder
    UIImage *toNSData;
    toNSData = [self scaleAndRotateImage:profileIm.image];

    NSData *imageData = UIImageJPEGRepresentation(toNSData, 0.5);
    
    NSString *urlString = @"http://thefourthc.info/EyesEverywhere/upload2341upload/uploadPro.php";
    
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
    
    NSString *headerIMG = @"thefourthc.info/EyesEverywhere/upload2341upload/pros/tn_";
    
    imageLoc = [NSString stringWithFormat:@"%@%@",headerIMG,returnString];
    
    // finish image upload
    // add image location to user database
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/p1h6p5/updatePro.php?username=%@&imgloc=%@", usernameField.text, imageLoc]];
        
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSData *urlData;
    NSURLResponse *response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    // it by storing in a temporary file and working with NSStrings  
    

    // end add image location
    
    UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Finished" message:@"Thanks for signing up! You may now log in!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertsuccess show];
    
    //stop network spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //stop activity bar
    [activityView stopAnimating];
    
    // end activity spinner/bar -- show alert success
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.userName = [NSString stringWithFormat:@"%@",usernameField.text];
    appDelegate.userNeww = [NSString stringWithFormat:@"YES"];
    
    BaseViewController *Base = [[BaseViewController alloc] initWithNibName:nil bundle:nil];
    [self presentModalViewController:Base animated:YES];
}


- (IBAction)checkboxButton:(id)sender{
	if (checkboxSelected == 0){
		[checkboxButton setSelected:YES];
		checkboxSelected = 1;
	} else {
		[checkboxButton setSelected:NO];
		checkboxSelected = 0;
	}
}


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
    
    
    [self.emailField setReturnKeyType:UIReturnKeyDone];
    [self.emailField addTarget:self
                        action:@selector(textFieldFinished:)
              forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.usernameField setReturnKeyType:UIReturnKeyDone];
    [self.usernameField addTarget:self
                           action:@selector(textFieldFinished:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.passwordField setReturnKeyType:UIReturnKeyDone];
    [self.passwordField addTarget:self
                           action:@selector(textFieldFinished:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    passwordField.secureTextEntry = YES;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)textFieldFinished:(id)sender
{
    // [sender resignFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    emailField.text = @"";
    usernameField.text = @"";
    passwordField.text = @"";
    //profileIm.image = [UIImage imageNamed:@"111-user@2x.png"];
    profileIm.image = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return (interfaceOrientation == UIInterfaceOrientationPortrait); 
}

//fix rotate
- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 150; // Or whatever
    
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

- (void) threadStartAnimating:(id)data {
    
    //// start activity indicator
    activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake(0, 0, 30.0, 30.0);
    activityView.backgroundColor = [UIColor lightGrayColor];
    activityView.center = self.view.center;
    [self.view addSubview: activityView];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [activityView startAnimating];
    
    
    //end activity indicator
}

@end
