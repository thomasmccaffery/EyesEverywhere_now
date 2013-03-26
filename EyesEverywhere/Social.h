//
//  Social.h
//  EyesEverywhere
//
//  Created by Tom on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Social : UIViewController <UITextViewDelegate> {
    IBOutlet UIScrollView* scrollView;
    
    IBOutlet UITextView *Form;

   // IBOutlet UIButton *SubmitButton;
    IBOutlet UIActivityIndicatorView * activityView;

}

@property (nonatomic, strong) UITextView *Form;
//@property (nonatomic, strong) UIButton *SubmitButton;

@property(nonatomic,retain)  UIActivityIndicatorView * activityView;

-(void)sendData;
-(void)clearer;


-(IBAction)submiter:(id)sender;

@end
