//
//  CommentsCell.m
//  EyesEverywhere
//
//  Created by N210 on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommentsCell.h"

@implementation CommentsCell

@synthesize RDLabel = _RDLabel;
@synthesize CImage = _CImage;
@synthesize username, numlabel;

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

-(void)viewDidLoad {
    [_RDLabel setNumberOfLines:0];
    [_RDLabel sizeToFit];
}

@end
