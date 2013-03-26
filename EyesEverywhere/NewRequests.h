//
//  NewRequests.h
//  EyesEverywhere
//
//  Created by Tom on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface NewRequests : UIViewController <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate, UIActionSheetDelegate> {
    IBOutlet UITextField *RTitle;
    IBOutlet UITextView *RDesc;
    IBOutlet UIImageView *imageView;
    
    CLLocationManager *locationManager;
    
    UIActivityIndicatorView * activityView;
    
    IBOutlet UIButton *photoButton;
    IBOutlet UILabel *warning;
}

@property (nonatomic, strong) UITextField *RTitle;
@property (nonatomic, strong) UITextView *RDesc;

@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;

-(IBAction)pushPick:(id)sender;
- (IBAction)pushUpload:(id)sender;

- (void)loadDat;
-(void)takePhoto;
-(void)libr;


@property(nonatomic,retain)  UIActivityIndicatorView * activityView;

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UILabel *warning;

- (UIImage *)scaleAndRotateImage:(UIImage *)image;


@end
