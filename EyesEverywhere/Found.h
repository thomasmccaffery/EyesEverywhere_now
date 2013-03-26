//
//  Found.h
//  EyesEverywhere
//
//  Created by Tom on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface Found : UIViewController <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate> {
    NSString *RNDer;
    IBOutlet UITextView *CDesc;
    IBOutlet UIImageView *imageCView;

    IBOutlet UIActivityIndicatorView * activityView;

    IBOutlet UIButton *photoButton;
    IBOutlet UIButton *backButton;
}

@property (nonatomic, retain) NSString *RNDer;
@property (nonatomic, strong) UITextView *CDesc;


-(IBAction)pushPick:(id)sender;
- (IBAction)pushUpload:(id)sender;

- (void)loadImage;
- (void)displayImage;

-(void)takePhoto;
-(void)libr;

@property(nonatomic,retain)  UIActivityIndicatorView * activityView;

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *backButton;

- (UIImage *)scaleAndRotateImage:(UIImage *)image;

@end
