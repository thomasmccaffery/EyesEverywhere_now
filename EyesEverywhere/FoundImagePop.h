//
//  FoundImagePop.h
//  EyesEverywhere
//
//  Created by Tom on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundImagePop : UIViewController {
    NSString *RequestedImage;
    IBOutlet UIImageView *requestImage;
    IBOutlet UILabel *loading;
    
    IBOutlet UILabel *date;

    IBOutlet UILabel *user;
    IBOutlet UILabel *CCdesc;
    
    IBOutlet UIActivityIndicatorView * activityView;
    
    IBOutlet UIButton *doeButton;

}

@property (nonatomic, retain) NSString *requestedImage;
@property (nonatomic, retain) UILabel *date;
@property (nonatomic, retain) UILabel *user;
@property (nonatomic, retain) UILabel *CCdesc;
@property (nonatomic, retain) UILabel *loading;

- (void)loadImage;
- (void)displayImage:(UIImage *)image;

@property (nonatomic, retain) NSDictionary* diction;

@property(nonatomic,retain)  UIActivityIndicatorView * activityView;
@property (nonatomic, strong) UIButton *doneButton;



@end
