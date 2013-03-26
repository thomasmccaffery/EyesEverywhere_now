//
//  Hits.m
//  EyesEverywhere
//
//  Created by Tom on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Hits.h"
#import "JSONKit.h"
#import "HitsVC.h"
#import "AppDelegate.h"
#import "Reachability.h"


#define REFRESH_HEADER_HEIGHT 52.0f


@implementation Hits {
    NSInteger toggler;
    NSInteger pagesys;
    float version;
}

@synthesize segmentedControl;
@synthesize itemsList,myTableView;
@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;
@synthesize postIt,closerButton;
@synthesize locationManager;
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

-(IBAction) segmentedControlIndexChanged{
	switch (self.segmentedControl.selectedSegmentIndex) {
		case 0: {
            //start network spinner
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

            toggler = 1;
            pagesys = 1;
            [self performSelector:@selector(tablerunner) withObject:nil];
			break;
        }
		case 1: {
            //start network spinner
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

            toggler = 2;
            pagesys = 1;
            locationManager.delegate = self;
            [locationManager startUpdatingLocation];
            

			break;
        }
		default:
            break;
    }
    
}


#pragma mark - View lifecycle

- (void) viewDidAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    [self.navigationController setNavigationBarHidden:TRUE animated:NO];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    [self.navigationController setNavigationBarHidden:TRUE animated:NO];

    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    toggler = 1;
    pagesys = 1;
    
    
    version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version > 3.19) {
        //Add a left swipe gesture recognizer
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self.myTableView addGestureRecognizer:recognizer];
        [recognizer release];    
        
        //Add a right swipe gesture recognizer
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self 
                                                               action:@selector(handleSwipeRight:)];
        recognizer.delegate = self;
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self.myTableView addGestureRecognizer:recognizer];
        [recognizer release];   
    } else {
        // pre 3.2 -- sadly add buttons on the bottom bar!
    }
    
    postIt.hidden = YES;
    closerButton.hidden = YES;
    
    
    if ([appDelegate.userNeww isEqualToString:@"YES"]) {
        postIt.hidden = NO;
        closerButton.hidden = NO;
        appDelegate.userNeww = [NSString stringWithFormat:@"NO"];
    } else {
        postIt.hidden = YES;
        closerButton.hidden = YES;
    }
    

    [self setupStrings];
    [self addPullToRefreshHeader];
    
    //start network spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    
    [self performSelector:@selector(tablerunner) withObject:nil];

    

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

// Below: Pull to Reload

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor darkGrayColor];
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
    [self.myTableView addSubview:refreshHeaderView];
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
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.myTableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.myTableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
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
    self.myTableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];

    pagesys = 1;
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self performSelector:@selector(tablerunner) withObject:nil];
    } else {
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];

    }

    
    // Refresh action!
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.myTableView.contentInset = UIEdgeInsetsZero;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

// TableView Customize

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [itemsList count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    HitsCell *cell = (HitsCell *)[myTableView dequeueReusableCellWithIdentifier:[HitsCell reuseIdentifier]];
    
    
    static NSString *postCellId = @"postCell";
	static NSString *moreCellId = @"moreCell";
	
	NSUInteger row = [indexPath row];
	NSUInteger count = [itemsList count];
	
	if (row == count) {
		cell = [tableView dequeueReusableCellWithIdentifier:moreCellId];
		if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"HitsCell" owner:self options:nil];
            cell = _customCell;
            _customCell = nil;

		}
        if (version < 3.19) {
            cell.RtitleLabel.text = @"<-- Click for more -->";
            cell.RtitleLabel.textColor = [UIColor blueColor];
            cell.RtitleLabel.font = [UIFont boldSystemFontOfSize:14];
        } else {
            cell.RtitleLabel.text = @"<-- Swipe for more -->";
            cell.RtitleLabel.textColor = [UIColor blueColor];
            cell.RtitleLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.userInteractionEnabled = NO;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
	} else {
        
		cell = [tableView dequeueReusableCellWithIdentifier:postCellId];
		if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"HitsCell" owner:self options:nil];
            cell = _customCell;
            _customCell = nil;
		}
        
        
        // Set up the cell...
        NSDictionary *dict = [itemsList objectAtIndex:indexPath.row];
        
        
        cell.RtitleLabel.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"Rtitle"]];
        [cell.RtitleLabel setNumberOfLines:0];
        [cell.RtitleLabel sizeToFit];

        cell.UserLabel.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"username"]];
        
    
        // get image from login table
        NSString *urlimg = [NSString stringWithFormat:@"http://%@", [dict objectForKey:@"profile"]];
        
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlimg]];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        [cell.profilerT setImage:image];
        
        if (indexPath.row == 0) {
            [cell.pushpinsL setImage:[UIImage imageNamed:@"PushPin_Red.png"]];
            [cell.pushpinsR setImage:[UIImage imageNamed:@"PushPin_Red.png"]];
            // last cell check
        } else if (indexPath.row == 1) {
            [cell.pushpinsL setImage:[UIImage imageNamed:@"PushPin_Blue.png"]];
            [cell.pushpinsR setImage:[UIImage imageNamed:@"PushPin_Blue.png"]];
        } else if (indexPath.row == 2) {
            [cell.pushpinsL setImage:[UIImage imageNamed:@"PushPin_Green.png"]];
            [cell.pushpinsR setImage:[UIImage imageNamed:@"PushPin_Green.png"]];
        } else if (indexPath.row == 3) {
            [cell.pushpinsL setImage:[UIImage imageNamed:@"PushPin_Yellow.png"]];
            [cell.pushpinsR setImage:[UIImage imageNamed:@"PushPin_Yellow.png"]];      
        } else if (indexPath.row == 4) {
            [cell.pushpinsL setImage:[UIImage imageNamed:@"PushPin_Orange.png"]];
            [cell.pushpinsR setImage:[UIImage imageNamed:@"PushPin_Orange.png"]];
        } else if (indexPath.row == indexPath.row) {
            [cell.pushpinsL setImage:[UIImage imageNamed:@"PushPin_Pink.png"]];
            [cell.pushpinsR setImage:[UIImage imageNamed:@"PushPin_Pink.png"]];
        } else {
            [cell.pushpinsL setImage:[UIImage imageNamed:@"PushPin_Red.png"]];
            [cell.pushpinsR setImage:[UIImage imageNamed:@"PushPin_Red.png"]];
        } 
     
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

    
	
	return cell;
}

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     
     //start network spinner
     [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
     
     

     NSUInteger row = [indexPath row];
     NSUInteger count = [itemsList count];
     
     if (row == count) { 
         // find way to make these not "selectable"
         if (version < 3.19) {
             // temporary fix below without buttons!
             if (toggler == 1) {
                 if ([itemsList count] == 5) {
                     //start network spinner
                     [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                     pagesys = pagesys+1;
                     [self performSelector:@selector(tablerunner) withObject:nil];
                 } else {
                     // alert view
                     // alert success on submitting
                     UIAlertView *alertNoMORE = [[UIAlertView alloc] initWithTitle:@"END" message:@"No more Hits left - you've reached the end! Try pulling down to refresh for new hits!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alertNoMORE show];
                 }
             } else if(toggler == 2) {
                 if ([itemsList count] == 5) {
                     //start network spinner
                     [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                     
                     pagesys = pagesys+1;
                     locationManager.delegate = self;
                     [locationManager startUpdatingLocation];
                 } else {
                     UIAlertView *alertNoMOREL = [[UIAlertView alloc] initWithTitle:@"END" message:@"No more Local Hits left - you've reached the end! Try pulling down to refresh for new local hits!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alertNoMOREL show];
                 }
             }

         } else {
                    //do nothing
         }
     } else {
     NSString *selectedCellItem = [NSString stringWithFormat:@"%d", indexPath.row];
     
     NSDictionary *dict = [itemsList objectAtIndex:indexPath.row];
 
     HitsVC *fvController = [[HitsVC alloc] initWithNibName:@"HitsVC" bundle:[NSBundle mainBundle]];
     fvController.selectedCellItem = selectedCellItem;
     fvController.myDict = dict;
     [self.navigationController pushViewController:fvController animated:YES];
     [fvController release];
     fvController = nil;
     }
     
     //stop network spinner
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

     
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
 }
 

- (void)tablerunner {
    
    
	itemsList = [[NSMutableArray alloc] init];
        
    NSString* theURL = [NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/iphoneReq.php?pagein=%i",pagesys];
    
    NSError *err = nil;
    NSURLResponse *response = nil;
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    NSURL *URL = [NSURL URLWithString:theURL];
    [request setURL:URL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSDictionary *resultsDictionary;
    
    NSDictionary *tempDictionary = [data objectFromJSONData];
    resultsDictionary = [tempDictionary copy];
    
    if(resultsDictionary) {
        itemsList = [resultsDictionary objectForKey:@"requests"];
    }
    
    [myTableView reloadData];
    
    //stop network spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [self.myTableView setContentOffset:CGPointZero animated:YES];

}


-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation{
    [locationManager stopUpdatingLocation];
    [manager stopUpdatingLocation];
    
    
    
    locationManager.delegate = nil;
        
    itemsList = [[NSMutableArray alloc] init];
    
    NSString *latt = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
	NSString *lonn = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    
    
    NSString* theURL = [NSString stringWithFormat:@"http://thefourthc.info/EyesEverywhere/iphoneReqLoc.php?lat=%@&lon=%@&pagein=%i",latt,lonn,pagesys];
    
    NSError *err = nil;
    NSURLResponse *response = nil;
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    NSURL *URL = [NSURL URLWithString:theURL];
    [request setURL:URL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSDictionary *resultsDictionary;
    
    NSDictionary *tempDictionary = [data objectFromJSONData];
    resultsDictionary = [tempDictionary copy];
    
    if(resultsDictionary) {
        itemsList = [resultsDictionary objectForKey:@"requestsLoc"];
    }
    
    [myTableView reloadData];
    //stop network spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [self.myTableView setContentOffset:CGPointZero animated:YES];
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if (toggler == 1) {
        if ([itemsList count] == 5) {
            //start network spinner
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

            pagesys = pagesys+1;
            [self performSelector:@selector(tablerunner) withObject:nil];
        } else {
            // alert view
            // alert success on submitting
            UIAlertView *alertNoMORE = [[UIAlertView alloc] initWithTitle:@"END" message:@"No more Hits left - you've reached the end! Try pulling down to refresh for new hits!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertNoMORE show];
        }
    } else if(toggler == 2) {
        if ([itemsList count] == 5) {
            //start network spinner
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

            pagesys = pagesys+1;
            locationManager.delegate = self;
            [locationManager startUpdatingLocation];
        } else {
            UIAlertView *alertNoMOREL = [[UIAlertView alloc] initWithTitle:@"END" message:@"No more Local Hits left - you've reached the end! Try pulling down to refresh for new local hits!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertNoMOREL show];
        }

    }
        
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if (toggler == 1) {
        if (pagesys != 1) {
            //start network spinner
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

            pagesys = pagesys-1;
            [self performSelector:@selector(tablerunner) withObject:nil];
        } else {
            // alert view
            // alert success on submitting
            UIAlertView *alertNoMORE = [[UIAlertView alloc] initWithTitle:@"Wrong Way" message:@"Swipe other direction for more Hits!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertNoMORE show];
        }
        
    } else if(toggler == 2) {
        if (pagesys != 1) {
            //start network spinner
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

            pagesys = pagesys-1;
            locationManager.delegate = self;
            [locationManager startUpdatingLocation];
        } else {
            // alert view
            // alert success on submitting
            UIAlertView *alertNoMORE = [[UIAlertView alloc] initWithTitle:@"Wrong Way" message:@"Swipe other direction for more Hits!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertNoMORE show];
        }
    }
}

-(IBAction)closer:(id)sender
{
    closerButton.hidden = YES;
    postIt.hidden = YES;   
}

-(IBAction)noteOpen:(id)sender
{
    closerButton.hidden = NO;
    postIt.hidden = NO;   
}

@end
