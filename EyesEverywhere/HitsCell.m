//
//  HitsCell.m
//  EyesEverywhere
//
//  Created by Tom on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HitsCell.h"

@implementation HitsCell

@synthesize RtitleLabel,UserLabel,profilerT,pushpinsL,pushpinsR;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier {   
    return @"CustomCellIdentifier";
}


@end
