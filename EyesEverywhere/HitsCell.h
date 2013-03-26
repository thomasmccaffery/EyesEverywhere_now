//
//  HitsCell.h
//  EyesEverywhere
//
//  Created by Tom on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HitsCell : UITableViewCell 
+ (NSString *)reuseIdentifier;
@property (strong,nonatomic) IBOutlet UILabel *RtitleLabel;
@property (strong,nonatomic) IBOutlet UILabel *UserLabel;
@property (strong,nonatomic) IBOutlet UIImageView *profilerT;
@property (strong,nonatomic) IBOutlet UIImageView *pushpinsL;
@property (strong,nonatomic) IBOutlet UIImageView *pushpinsR;






@end
