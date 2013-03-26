//
//  Favorites.m
//  EyesEverywhere
//
//  Created by Tom on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Favorites.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "HitsVC.h"
#import "Reachability.h"

@implementation Favorites

@synthesize reqList,favList,tblSimpleTable;
@synthesize favsReset, profileIMG, user;
@synthesize activityView;
@synthesize feature2Btn,featureLabel,statusLabel;


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

- (void) viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:TRUE animated:YES];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];    
    
    
	reqList = [[NSMutableArray alloc] init];

    
    NSString* theURL = [NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/iphoneReQs.php?username=%@",appDelegate.userName];
    
    NSError *err = nil;
    NSURLResponse *response = nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSURL *URL = [NSURL URLWithString:theURL];
    [request setURL:URL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSDictionary *resultsDictionary;
    
    NSDictionary *tempDictionary = [data objectFromJSONData];
    resultsDictionary = [tempDictionary copy];
    
    if(resultsDictionary) {
        reqList = [resultsDictionary objectForKey:@"reqs"];
    }
    
    //set arryCurrent -- all current requests of user
    arryCurrent = [(NSArray*)reqList mutableCopy];

    
    // get favorites below:
    
    NSString* favURL = [NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/iphoneFaVs.php?username=%@",appDelegate.userName];
    
    NSError *errf = nil;
    NSURLResponse *responsef = nil;
    NSMutableURLRequest *requestf = [[NSMutableURLRequest alloc] init];
    
    NSURL *URLf = [NSURL URLWithString:favURL];
    [requestf setURL:URLf];
    [requestf setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [requestf setTimeoutInterval:30];
    
    NSData *dataf = [NSURLConnection sendSynchronousRequest:requestf returningResponse:&responsef error:&errf];
    
    NSDictionary *resultsDictionaryf;
    
    NSDictionary *tempDictionaryf = [dataf objectFromJSONData];
    resultsDictionaryf = [tempDictionaryf copy];
    
    if(resultsDictionaryf) {
        favList = [resultsDictionaryf objectForKey:@"favs"];
    }

    
    //set arryFAvs -- all favorites of user 
    arryFavs = [(NSArray*)favList mutableCopy];
    [tblSimpleTable reloadData];

    statusLabel.text = @"";
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:TRUE animated:NO];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];    

    
	reqList = [[NSMutableArray alloc] init];
    
    
    NSString* theURL = [NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/iphoneReQs.php?username=%@",appDelegate.userName];
    
    NSError *err = nil;
    NSURLResponse *response = nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSURL *URL = [NSURL URLWithString:theURL];
    [request setURL:URL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSDictionary *resultsDictionary;
    
    NSDictionary *tempDictionary = [data objectFromJSONData];
    resultsDictionary = [tempDictionary copy];
    
    if(resultsDictionary) {
        reqList = [resultsDictionary objectForKey:@"reqs"];
    }
    
    //set arryCurrent -- all current requests of user
    arryCurrent = [(NSArray*)reqList mutableCopy];

    // get favorites below:
    
    NSString* favURL = [NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/iphoneFaVs.php?username=%@",appDelegate.userName];
    
    NSError *errf = nil;
    NSURLResponse *responsef = nil;
    NSMutableURLRequest *requestf = [[NSMutableURLRequest alloc] init];
    
    NSURL *URLf = [NSURL URLWithString:favURL];
    [requestf setURL:URLf];
    [requestf setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [requestf setTimeoutInterval:30];
    
    NSData *dataf = [NSURLConnection sendSynchronousRequest:requestf returningResponse:&responsef error:&errf];
    
    NSDictionary *resultsDictionaryf;
    
    NSDictionary *tempDictionaryf = [dataf objectFromJSONData];
    resultsDictionaryf = [tempDictionaryf copy];
    
    if(resultsDictionaryf) {
        favList = [resultsDictionaryf objectForKey:@"favs"];
    }
    
    //set arryFAvs -- all favorites of user 
    arryFavs = [(NSArray*)favList mutableCopy];
    
    //Get url for profile image
    NSString *imgstr =[NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/p1h6p5/portfolio_image.php?username=%@",appDelegate.userName];
    NSData *dataURL =  [NSData dataWithContentsOfURL: [ NSURL URLWithString: imgstr]];    
    NSString *serverOutput = [[NSString alloc] initWithData:dataURL encoding: NSASCIIStringEncoding];
    NSString *trimmedString = [serverOutput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // set profile image
    NSString *urlimg = [NSString stringWithFormat:@"http://%@", trimmedString];
    
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlimg]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    [profileIMG setImage:image];
        
    // set username label
    NSString *ustr =[NSString stringWithFormat:@"%@",appDelegate.userName];
    user.text = ustr;


    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] == ReachableViaWiFi) {
        // Do something that requires wifi
    } else if ([[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] == ReachableViaWWAN) {
        // Do something that doesnt require wifi
    } else if ([[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] == NotReachable) {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"No Internet Connection!" message:@"Sorry, but no internet connectivity was found. EyesEverywhere needs an internet connection! Please connect to wifi or data source such as 3G/4G." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];    
    }
    
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

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == 0)
		return [arryCurrent count];
	else
		return [arryFavs count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if(section == 0){
		return @"Your Active Requests:";
	}else{
		return @"Favorites:";
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	if(section == 0){
		return @"To stop (delete) any of Your Active Requests, simply swipe the title and delete.";
	}else{
		return @"To remove favorites, swipe the row and click delete.";
	}
}


// Customize the appearance of table view cells.
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set up the cell...
	if(indexPath.section == 0){
        UIImageView *background;
        //customize requests
        // first cell check
        if (indexPath.row == 0) {
            background = [[UIImageView alloc] initWithImage:
                          [UIImage imageNamed:@"top-cell.png"]];
            // last cell check
        } else if (indexPath.row ==
                   [tableView numberOfRowsInSection:indexPath.section] - 1) {
            background = [[UIImageView alloc] initWithImage:
                          [UIImage imageNamed:@"bottom-cell.png"]];
            // middle cells
        } else {
            background = [[UIImageView alloc] initWithImage:
                          [UIImage imageNamed:@"middle-cell.png"]];
        }
        [cell setBackgroundView:background];
	}else{
        //customize favs
        UIImageView *backgroundF;
        //customize requests
        // first cell check
        if (indexPath.row == 0) {
            backgroundF = [[UIImageView alloc] initWithImage:
                          [UIImage imageNamed:@"top-cell.png"]];
            // last cell check
        } else if (indexPath.row ==
                   [tableView numberOfRowsInSection:indexPath.section] - 1) {
            backgroundF = [[UIImageView alloc] initWithImage:
                          [UIImage imageNamed:@"bottom-cell.png"]];
            // middle cells
        } else {
            backgroundF = [[UIImageView alloc] initWithImage:
                          [UIImage imageNamed:@"middle-cell.png"]];
        }
        [cell setBackgroundView:backgroundF];
	}
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
	if(indexPath.section == 0){
        NSDictionary *dict = [reqList objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"Rtitle"]];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];

	}else{
        NSDictionary *dictf = [favList objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [dictf objectForKey:@"Rtitle"]];
        cell.textLabel.backgroundColor = [UIColor clearColor];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *selectedCellItem = [NSString stringWithFormat:@"%d", indexPath.row];
        
    HitsVC *fvController = [[HitsVC alloc] initWithNibName:@"HitsVC" bundle:[NSBundle mainBundle]];
    fvController.selectedCellItem = selectedCellItem;

	if(indexPath.section == 0) {
        NSDictionary *dict = [arryCurrent objectAtIndex:indexPath.row];
        
        fvController.myDict = dict;
        
    } else {
        
        NSDictionary *dict2 = [arryFavs objectAtIndex:indexPath.row];
        
        NSString* pushURL = [NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/iphoneFavPusher.php?RND=%@",[dict2 objectForKey:@"RND"]];
        
        NSError *errp = nil;
        NSURLResponse *responsep = nil;
        NSMutableURLRequest *requestp = [[NSMutableURLRequest alloc] init];
        
        NSURL *URLp = [NSURL URLWithString:pushURL];
        [requestp setURL:URLp];
        [requestp setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [requestp setTimeoutInterval:30];
        
        NSData *datap = [NSURLConnection sendSynchronousRequest:requestp returningResponse:&responsep error:&errp];
        
        NSDictionary *resultsDictionaryp;
        
        NSDictionary *tempDictionaryp = [datap objectFromJSONData];
        resultsDictionaryp = [tempDictionaryp copy];
        
        NSMutableArray *pushList;
        
        if(resultsDictionaryp) {
            pushList = [resultsDictionaryp objectForKey:@"pushing"];
        }
        
        NSDictionary *dictpush = [pushList objectAtIndex:0];        
                
        fvController.myDict = dictpush;
        
    }
    
    [self.navigationController pushViewController:fvController animated:YES];
    fvController = nil;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        if(indexPath.section == 0) { 
            NSDictionary *dict = [arryCurrent objectAtIndex: indexPath.row];
            
            // Removes request from SQL
            
            NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/iphoneReMoVeHiTs.php?RND=%@", [dict objectForKey:@"RND"]]];
            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            
            NSData *urlData;
            NSURLResponse *response;
            urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
            
            
            [arryCurrent removeObjectAtIndex:indexPath.row];
            [tblSimpleTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        }
        else {
        
        NSDictionary *dict = [arryFavs objectAtIndex: indexPath.row];
        
        // Removes favorite from SQL
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];    
        
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/iphoneaDDfAv.php?username=%@&RND=%@",appDelegate.userName, [dict objectForKey:@"RND"]]];
        
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        
        NSData *urlData;
        NSURLResponse *response;
        urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];

        
        [arryFavs removeObjectAtIndex:indexPath.row];
        [tblSimpleTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
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
}

-(void)libr {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:picker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
	[picker.parentViewController dismissModalViewControllerAnimated:YES];
	profileIMG.image = image;
    
    
     //// start activity indicator
     activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
     activityView.frame = CGRectMake(0, 0, 40.0, 40.0);
     activityView.center = self.view.center;
     [self.view addSubview: activityView];
     
     //start network spinner
     [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
     
     [activityView startAnimating];
     //end activity indicator
     
    
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
                                        initWithTarget:self
                                        selector:@selector(updater) 
                                        object:nil];
    [queue addOperation:operation];
    
}

- (void)updater {
    
    
    // upload image and send to sql
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *imageLoc;
    
    // start push image -- to /pro folder
    UIImage *toNSData;
    toNSData = [self scaleAndRotateImage:profileIMG.image];
    NSData *imageData = UIImageJPEGRepresentation(toNSData, 0.2);
    
    NSString *urlString = @"http://thefourthc.info/EyesEverywhere/upload2341upload/uploadPro.php";
    
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
        
    NSString *headerIMG = @"thefourthc.info/EyesEverywhere/upload2341upload/pros/tn_";
    
    imageLoc = [NSString stringWithFormat:@"%@%@",headerIMG,returnString];
    
    // finish image upload
    // add image location to user database
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/p1h6p5/updatePro.php?username=%@&imgloc=%@", appDelegate.userName, imageLoc]];
        
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSData *urlData;
    NSURLResponse *response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    // it by storing in a temporary file and working with NSStrings  
    
    // end add image location
    
    UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Profile Updated!" message:@"Your profile image has now been updated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertsuccess show];
    
    
    //stop network spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //stop activity bar
    [activityView stopAnimating];
    
    // end activity spinner/bar -- show alert success

}

- (IBAction)logout:(id)sender {
    // logout action
    
    [self dismissModalViewControllerAnimated:YES];
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

// Start - IN - App purchase

-(IBAction)doFeature2:(id)sender {  
    
    featureLabel.text = @"Clicked!";  
    
    askToPurchase = [[UIAlertView alloc]  
                     
                     initWithTitle:@"Out of Requests?"  
                     
                     message:@"Would you like to Purchase three (3) More Requests?"  
                     
                     delegate:self  
                     
                     cancelButtonTitle:nil  
                     
                     otherButtonTitles:@"Yes", @"No", nil];  
    
    askToPurchase.delegate = self;  
    
    [askToPurchase show];  
    
}  

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {  
    if (alertView==askToPurchase) {  
        if (buttonIndex==0) {  

            // user tapped YES, but we need to check if IAP is enabled or not.  
            
            if ([SKPaymentQueue canMakePayments]) {  

                SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"re.EyesEverywhe.EyesEverywhere.threemore"]];   

                request.delegate = self;   
                
                [request start];   
            } else {  
                UIAlertView *tmp = [[UIAlertView alloc]  
                                    
                                    initWithTitle:@"Prohibited"  
                                    
                                    message:@"Parental Control is enabled, cannot make a purchase!"  
                                    
                                    delegate:self  
                                    
                                    cancelButtonTitle:nil  
                                    
                                    otherButtonTitles:@"Ok", nil];  
                
                [tmp show];  

            }  
            
        }  
        
    }  
    
}  

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response   

{   
    // remove wait view here  
    statusLabel.text = @"";


    SKProduct *validProduct = nil;  
    
    int count = [response.products count];  
    NSLog(@"step 4: get counter: %i", count);
        
    if (count>0) {  
        
        validProduct = [response.products objectAtIndex:0];  
        
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"re.EyesEverywhe.EyesEverywhere.threemore"];  
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];  

        [[SKPaymentQueue defaultQueue] addPayment:payment];  
    } else {  
        UIAlertView *tmp = [[UIAlertView alloc]  
                            
                            initWithTitle:@"Not Available"  
                            
                            message:@"No products to purchase"  
                            
                            delegate:self  
                            
                            cancelButtonTitle:nil  
                            
                            otherButtonTitles:@"Ok", nil];  
        
        [tmp show];  
    }  
    
}   

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: {
                
                // show wait view here
                statusLabel.text = @"Processing...";

            } break;
                
            case SKPaymentTransactionStatePurchased: {

                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                // remove wait view and unlock feature 2
                statusLabel.text = @"Purchase Complete!";
                UIAlertView *tmp = [[UIAlertView alloc] 
                                    initWithTitle:@"Purchase Complete" 
                                    message:@"You have unlocked 3 more Requests! Now go search what you're looking for, and Thank You for using EyesEverywhere!"
                                    delegate:self 
                                    cancelButtonTitle:nil 
                                    otherButtonTitles:@"Ok", nil]; 
                [tmp show];                
                
               // NSError *error = nil;
                //Update SQL/PHP for +1 LTBuy, +3 Extra-Req
               
                //[SFHFKeychainUtils storeUsername:@"IAPNoob01" andPassword:@"whatever" forServiceName:kStoredData updateExisting:YES error:&error];
                
                
                // do other thing to enable the features                
                
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];    

                NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/p1h6p5/iphone1205AdDuPIAP.php?username=%@", appDelegate.userName]];
                
                NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
                
                NSData *urlData;
                NSURLResponse *response;
                urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
                
            } break;
                
            case SKPaymentTransactionStateRestored: {

                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                // remove wait view here
                statusLabel.text = @"";
            }
             break;
                
            case SKPaymentTransactionStateFailed: 
            {   
                if (transaction.error.code != SKErrorPaymentCancelled) {

                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                // remove wait view here
                statusLabel.text = @"Purchase Error!";
            } break;
                
            default:
            {
            }break;
        }
    }
}


-(void)request:(SKRequest *)request didFailWithError:(NSError *)error  
{  
    NSLog(@"Failed to connect with error: %@", [error localizedDescription]);  
}  




@end
