//
//  HitsVC.m
//  EyesEverywhere
//
//  Created by Tom on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HitsVC.h"
#import "Requests_ImageView.h"
#import "Found.h"
#import "FoundImagePop.h"
#import "AppDelegate.h"
#import "JSONKit.h"

#define REFRESH_HEADER_HEIGHT 52.0f



@implementation HitsVC {
    NSString *correctURL;
    NSString *correctURLCom;
    NSString *chk;
}

@synthesize selectedCellItem,myDict;
@synthesize loading;
@synthesize likebutton,photobutton;
@synthesize commentList,commentTableView,myDictCom;
@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;
@synthesize customCell = _customCell;


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

- (void) viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad
{
    
	self.navigationItem.title = @"Selected Item";
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(favs:)]; 
    
    NSString *author = [NSString stringWithFormat:@"By: %@", [myDict objectForKey:@"username"]];
    user.text = author;

    [rtitle setText: [myDict objectForKey:@"Rtitle"]];
    
    NSString *rdescc = [NSString stringWithFormat:@"Requested: %@", [myDict objectForKey:@"Rdesc"]];

    rdescc = [rdescc stringByReplacingOccurrencesOfString:@"R8D5" withString:@"\n"
                                                  options:NSRegularExpressionSearch
                                                    range:NSMakeRange(0, rdescc.length)];

    [desc setText: rdescc];
    [desc setNumberOfLines:0];
    [desc sizeToFit];        
    
    // added async
    NSString *urlls = [NSString stringWithFormat:@"%@", [myDict objectForKey:@"imgloc"]];
    
    urlls = [urlls stringByReplacingOccurrencesOfString:@"thefourthc.info/EyesEverywhere/upload2341upload/" withString:@"thefourthc.info/EyesEverywhere/upload2341upload/thumb/tn_" options:NSRegularExpressionSearch
                                                  range:NSMakeRange(0, urlls.length)];

    
    NSString *httpPrefix = @"http://";
    chk = @"http://none";
    correctURL = [httpPrefix stringByAppendingString:urlls];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
                                        initWithTarget:self
                                        selector:@selector(loadImage) 
                                        object:nil];
    [queue addOperation:operation]; 

    if ([correctURL isEqualToString:chk]) {
        loading.text = @"No Image Uploaded";
        photobutton.hidden = TRUE;
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];    
    
    // check if liked button clicked already
    NSString *hostStr =[NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/iphoneLikeCheck.php?username=%@&RND=%@",appDelegate.userName, [myDict objectForKey:@"RND"]];        
    
    NSData *dataURL =  [NSData dataWithContentsOfURL: [ NSURL URLWithString: hostStr ]];    
    NSString *serverOutput = [[NSString alloc] initWithData:dataURL encoding: NSASCIIStringEncoding];
    NSString *trimmedString = [serverOutput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([trimmedString isEqualToString:@"0yes"]) {//set image to like 
        UIImage *btnImage = [UIImage imageNamed:@"LikeButton.png"];
        [likebutton setImage:btnImage forState:UIControlStateNormal];

    } else { //set image to liked
        UIImage *btnImage = [UIImage imageNamed:@"LikedButton.png"];
        [likebutton setImage:btnImage forState:UIControlStateNormal];
    }
    
    [self setupStrings];
    [self addPullToRefreshHeader];
    [self performSelector:@selector(commentTable) withObject:nil];

    
    [super viewDidLoad];


    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)loadImage {
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:correctURL]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    [self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
}

- (void)displayImage:(UIImage *)image {
    if (![correctURL isEqualToString:chk]) {
        loading.text = @"";
    }
    [requestsImage setImage:image]; 
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

- (IBAction)favs:(id)sender{
    // add favs
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];    
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/iphoneaDDfAv.php?username=%@&RND=%@",appDelegate.userName, [myDict objectForKey:@"RND"]]];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSData *urlData;
    NSURLResponse *response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    
    UIAlertView *alertfav = [[UIAlertView alloc] initWithTitle:@"Favorite Added!" message:@"Your favorite has been added" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertfav show];
    
    
}

- (IBAction)thumbnail:(id)sender {
    // pushes a new view for full-screen image (requested)
    UINavigationController *Controller = [[UINavigationController alloc] init];
    Requests_ImageView *controller = [[Requests_ImageView alloc] init];
    NSString *urlls = [NSString stringWithFormat:@"%@", [myDict objectForKey:@"imgloc"]];
    
    NSString *httpPrefix = @"http://";
    
    NSString *correctURL2 = [httpPrefix stringByAppendingString:urlls];
    NSString *requestedImage = correctURL2;
    controller.requestedImage = requestedImage;
    Controller.viewControllers=[NSArray arrayWithObject:controller];
    
    [self presentModalViewController:Controller animated:YES];
}

- (IBAction)found:(id)sender {
    
    Found *fController = [[Found alloc] initWithNibName:@"Found" bundle:[NSBundle mainBundle]];

    NSString *urlls = [NSString stringWithFormat:@"%@", [myDict objectForKey:@"RND"]];
    
    NSString *RND = urlls;
    fController.RNDer = RND;
    
    [self.navigationController pushViewController:fController animated:YES];
    fController = nil;
}

- (IBAction)up:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];    
    
    // check if liked button clicked already
    NSString *hostStr =[NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/iphoneLikeCheck.php?username=%@&RND=%@",appDelegate.userName, [myDict objectForKey:@"RND"]];        
    
    NSData *dataURL =  [NSData dataWithContentsOfURL: [ NSURL URLWithString: hostStr ]];    
    NSString *serverOutput = [[NSString alloc] initWithData:dataURL encoding: NSASCIIStringEncoding];
    NSString *trimmedString = [serverOutput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([trimmedString isEqualToString:@"0yes"]) {
        
        NSURL *urlUP = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/iphoneVoTeUp.php?username=%@&RND=%@",appDelegate.userName, [myDict objectForKey:@"RND"]]];
        
        NSURLRequest *urlVUP = [NSURLRequest requestWithURL:urlUP];
        
        NSData *urlDataUP;
        NSURLResponse *responseUP;
        urlDataUP = [NSURLConnection sendSynchronousRequest:urlVUP returningResponse:&responseUP error:nil];
        
        UIImage *btnImage = [UIImage imageNamed:@"LikedButton.png"];
        [likebutton setImage:btnImage forState:UIControlStateNormal];
        
        UIAlertView *alertfav = [[UIAlertView alloc] initWithTitle:@"Voted!" message:@"Thanks for voting up!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertfav show];
    } else if ([trimmedString isEqualToString:@"1no"])
    {
        
        NSURL *urlDown = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/iphoneVoTeDoWn.php?username=%@&RND=%@",appDelegate.userName, [myDict objectForKey:@"RND"]]];
        
        NSURLRequest *urlVDown = [NSURLRequest requestWithURL:urlDown];
        
        NSData *urlDataDown;
        NSURLResponse *responseDown;
        urlDataDown = [NSURLConnection sendSynchronousRequest:urlVDown returningResponse:&responseDown error:nil];

        UIImage *btnImage = [UIImage imageNamed:@"LikeButton.png"];
        [likebutton setImage:btnImage forState:UIControlStateNormal];
        
        
        UIAlertView *alertfav = [[UIAlertView alloc] initWithTitle:@"Unliked!" message:@"Unliked!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertfav show];
    }
    else {
        UIAlertView *alertCON = [[UIAlertView alloc] initWithTitle:@"Connection-Error!" message:@"Connection Error, Please Try Again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertCON show];
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([response respondsToSelector:@selector(statusCode)])
    {
        int statusCode = [((NSHTTPURLResponse *)response) statusCode];
        if (statusCode == 404)
        {
            [connection cancel];  // stop connecting; no more delegate messages
        }
    }
}

// below starts comment table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [commentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentsCell *cell = (CommentsCell *)[commentTableView dequeueReusableCellWithIdentifier:[CommentsCell reuseIdentifier]];
		
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"CommentsCell" owner:self options:nil];
        cell = _customCell;
        _customCell = nil;
	}
	
	// Set up the cell...
    myDictCom = [commentList objectAtIndex:indexPath.row];
        
    NSString *labelText = [NSString stringWithFormat:@"%@", [myDictCom objectForKey:@"Cdesc"]];

    labelText = [labelText stringByReplacingOccurrencesOfString:@"%20" withString:@" "
                                                        options:NSRegularExpressionSearch
                                                          range:NSMakeRange(0, labelText.length)];
    labelText = [labelText stringByReplacingOccurrencesOfString:@"R8D5" withString:@"\n"
                                                        options:NSRegularExpressionSearch
                                                          range:NSMakeRange(0, labelText.length)];
    cell.RDLabel.text = [NSString stringWithFormat:@"Spotted: %@", labelText];
    cell.username.text = [NSString stringWithFormat:@"By: %@", [myDictCom objectForKey:@"username"]];
    cell.numlabel.text = [NSString stringWithFormat:@"#0%i", indexPath.row];    
    
    NSString *urlls = [NSString stringWithFormat:@"%@", [myDictCom objectForKey:@"imglocs"]];
    
    NSString *cutter = [NSString stringWithFormat:@"thefourthc.info/EyesEverywhere/upload2341upload/%@/", [myDict objectForKey:@"RND"]];
    
    NSString * filen = [urlls stringByReplacingOccurrencesOfString:cutter withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, urlls.length)];    
    
    NSString *urlNew = [NSString stringWithFormat:@"%@thumbs/tn_%@", cutter, filen];
    
    NSString *httpPrefix = @"http://";
    
    
    correctURLCom = [httpPrefix stringByAppendingString:urlNew];
    
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:correctURLCom]];
    
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    [cell.CImage setImage:image];    
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = [commentList objectAtIndex:indexPath.row];
    
    // pushes a new view for full-screen image (requested)
    UINavigationController *ControllerCom = [[UINavigationController alloc] init];
    FoundImagePop *controllerCom = [[FoundImagePop alloc] init];
    controllerCom.diction = dict;
    ControllerCom.viewControllers=[NSArray arrayWithObject:controllerCom];
    
    [self presentModalViewController:ControllerCom animated:YES];
    controllerCom = nil;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

-(void)commentTable {
    
    commentList = [[NSMutableArray alloc] init];
    
    NSString* theURL = [NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/iphoneComment.php?RND=%@", [myDict objectForKey:@"RND"]];
        
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
        commentList = [resultsDictionary objectForKey:@"Comments"];
    }
    
    [commentTableView reloadData];
    
}

- (void)loadImageCom {
    
    // added async
    NSString *urlls = [NSString stringWithFormat:@"%@", [myDictCom objectForKey:@"imglocs"]];
    
    NSString *httpPrefix = @"http://";
    
    
    correctURLCom = [httpPrefix stringByAppendingString:urlls];

    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:correctURLCom]];
    
    UIImage* image = [[UIImage alloc] initWithData:imageData];

    [self performSelectorOnMainThread:@selector(displayImageCom:) withObject:image waitUntilDone:NO];
}

- (void)displayImageCom:(UIImage *)image {
    CommentsCell *cell = (CommentsCell *)[commentTableView dequeueReusableCellWithIdentifier:[CommentsCell reuseIdentifier]];
    
    [cell.CImage setImage:image]; 
}

//above comment table view


// Below: Pull to Reload

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textColor = [UIColor whiteColor];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self.commentTableView addSubview:refreshHeaderView];
}

- (void)setupStrings{
    textPull = [[NSString alloc] initWithString:@"Pull down to refresh..."];
    textRelease = [[NSString alloc] initWithString:@"Release to refresh..."];
    textLoading = [[NSString alloc] initWithString:@"Loading..."];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    lastOffset = scrollView.contentOffset;

    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.commentTableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.commentTableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
    
    // header mover
    
    if (scrollView.contentOffset.y > 44) {        
        [self.navigationController setNavigationBarHidden:TRUE animated:YES];
    } else{
        [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.commentTableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
        [self performSelector:@selector(commentTable) withObject:nil];
   
    
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.commentTableView.contentInset = UIEdgeInsetsZero;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

//end pull to refresh

@end
