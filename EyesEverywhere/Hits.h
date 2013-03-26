//
//  Hits.h
//  EyesEverywhere
//
//  Created by Tom on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HitsCell.h"


@interface Hits : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UIGestureRecognizerDelegate>
{
    UISegmentedControl *segmentedControl;
    
    IBOutlet UIButton *closerButton;

    
	NSMutableArray *itemsList;
    
    IBOutlet UITableView *myTableView;

	//UITableView *myTableView;
    
    // pull to refresh
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
    CLLocationManager *locationManager;
    
}

//segment control
@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;

-(IBAction) segmentedControlIndexChanged;

//tableview
@property(nonatomic,retain)NSMutableArray *itemsList;
@property(nonatomic,retain)UITableView *myTableView;


//pull to refresh
@property (nonatomic, strong) UIView *refreshHeaderView;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UIImageView *refreshArrow;
@property (nonatomic, strong) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;

- (void)tablerunner;
//- (void)spinn;
//- (void)tablerunnerLoc;

@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;

// Customized Cell
@property (assign, nonatomic) IBOutlet HitsCell *customCell;

@property (strong,nonatomic) IBOutlet UIImageView *postIt;
@property (nonatomic, strong) UIButton *closerButton;


@end
