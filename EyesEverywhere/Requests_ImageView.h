//
//  Requests_ImageView.h
//  EyesEverywhere
//
//  Created by Tom on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Requests_ImageView : UIViewController {
    NSString *RequestedImage;
    IBOutlet UIImageView *requestImage;
    IBOutlet UILabel *loading;

    IBOutlet UIActivityIndicatorView * activityView;

    
}

@property (nonatomic, retain) NSString *requestedImage;
@property (nonatomic, retain) UILabel *loading;

- (void)loadImage;
- (void)displayImage:(UIImage *)image;

@property(nonatomic,retain)  UIActivityIndicatorView * activityView;


@end
