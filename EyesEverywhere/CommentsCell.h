//
//  CommentsCell.h
//  EyesEverywhere
//
//  Created by N210 on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsCell : UITableViewCell
+ (NSString *)reuseIdentifier;
@property (nonatomic, strong) IBOutlet UILabel *RDLabel;
@property (nonatomic, strong) IBOutlet UILabel *username;
@property (nonatomic, strong) IBOutlet UILabel *numlabel;

@property (nonatomic, strong) IBOutlet UIImageView *CImage;

@end
