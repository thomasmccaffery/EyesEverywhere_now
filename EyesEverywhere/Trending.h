//
//  Trending.h
//  EyesEverywhere
//
//  Created by Tom on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendCell.h"

@interface Trending : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *trendList;
    
    IBOutlet UITableView *trTableView;
        
    // pull to refreshend
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
}

//tableview
@property(nonatomic,retain)NSMutableArray *trendList;
@property(nonatomic,retain)UITableView *trTableView;


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

// Customized Cell
@property (assign, nonatomic) IBOutlet TrendCell *customCell;


@end
