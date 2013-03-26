//
//  Favorites.h
//  EyesEverywhere
//
//  Created by Tom on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>


@interface Favorites : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver> {
 	
    //NSMutableArray *itemsList;
        
    IBOutlet UITableView *tblSimpleTable;
	NSMutableArray *arryCurrent;
	NSMutableArray *arryFavs;
    
    NSMutableArray *reqList;
    NSMutableArray *favList;
    
    NSMutableArray *favsReset;
    
    //activity indictator
    UIActivityIndicatorView * activityView;
    
    // In-App purchase Button
    IBOutlet UIButton *feature2Btn;  
    IBOutlet UILabel *featureLabel, *statusLabel;  
    UIAlertView *askToPurchase;  
}

@property(nonatomic,retain)NSMutableArray *reqList;
@property(nonatomic,retain)NSMutableArray *favList;
@property(nonatomic,retain)UITableView *tblSimpleTable;

@property (nonatomic,strong) NSMutableArray *favsReset;

@property (strong,nonatomic) IBOutlet UILabel *user;
// profile image
@property (strong,nonatomic) IBOutlet UIImageView *profileIMG;

-(IBAction)profile:(id)sender;
-(void)takePhoto;
-(void)libr;
-(void)updater;

//activity indicator
@property(nonatomic,retain)  UIActivityIndicatorView * activityView;

- (UIImage *)scaleAndRotateImage:(UIImage *)image;

// In-App Purchase Button
@property (nonatomic, retain)  UIButton *feature2Btn;  
@property (nonatomic, retain)  UILabel *featureLabel, *statusLabel;  

-(IBAction)doFeature2:(id)sender;  

@end
