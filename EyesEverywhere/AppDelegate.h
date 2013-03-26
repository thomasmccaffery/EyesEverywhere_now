//
//  AppDelegate.h
//  EyesEverywhere
//
//  Created by Tom on 8/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSString *userName;
    NSString *userNeww;

}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userNeww;

@end
