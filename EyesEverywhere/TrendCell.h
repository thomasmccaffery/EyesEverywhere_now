//
//  TrendCell.h
//  EyesEverywhere
//
//  Created by Tom on 10/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendCell : UITableViewCell
+ (NSString *)reuseIdentifier;
@property (strong,nonatomic) IBOutlet UILabel *RtitleLabel;
@property (strong,nonatomic) IBOutlet UILabel *numLabel;
@property (strong,nonatomic) IBOutlet UIImageView *drop_pin;

@end
