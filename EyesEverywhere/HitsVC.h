//
//  HitsVC.h
//  EyesEverywhere
//
//  Created by Tom on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsCell.h"

@interface HitsVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSString *selectedCellItem;
    
    IBOutlet UILabel *user;
    IBOutlet UILabel *rtitle;
    IBOutlet UILabel *desc;
    IBOutlet UILabel *loading;
    IBOutlet UIImageView *requestsImage;

    UIAlertView *alertViewUP, *alertViewDOWN;
    
    IBOutlet UIButton *likebutton;
    IBOutlet UIButton *photobutton;
    
    //create comments table
    NSMutableArray *commentList;
	IBOutlet UITableView *commentTableView;
    
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
    
    CGPoint lastOffset;

}

@property (nonatomic, retain) NSString *selectedCellItem;
@property (nonatomic, retain) NSDictionary* myDict;
@property (nonatomic, retain) UILabel *loading;
@property (nonatomic, retain) UIButton *likebutton;
@property (nonatomic, retain) UIButton *photobutton;


- (IBAction)thumbnail:(id)sender;
- (IBAction)found:(id)sender;
- (IBAction)up:(id)sender;

//set comment table
@property(nonatomic,retain)NSMutableArray *commentList;
@property (nonatomic, retain) NSDictionary* myDictCom;
@property(nonatomic,retain)UITableView *commentTableView;

-(void)commentTable;

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

// Customized Cell
@property (assign, nonatomic) IBOutlet CommentsCell *customCell;


@end
