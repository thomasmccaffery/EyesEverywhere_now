    //
//  BaseViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//
// Copyright (c) 2011 Peter Boctor
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

#import "BaseViewController.h"


@implementation BaseViewController
@synthesize tabBarController;



// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
  UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
  button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
  [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
  [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];

  CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
  if (heightDifference < 0)
    button.center = self.tabBar.center;
  else
  {
    CGPoint center = self.tabBar.center;
    center.y = center.y - heightDifference/2.0;
    button.center = center;
  }
        
    [button addTarget:self action:@selector(centerButton:) forControlEvents:UIControlEventTouchUpInside];    

  
  [self.view addSubview:button];
}

-(void) centerButton:(id)sender {
    
    // create the view scalePicker, set it's title and place it on the top of the view hierarchy
    [self setSelectedIndex:2];
        
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait); 
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    nc1 = [[UINavigationController alloc] init];
    vc1 = [[Hits alloc] initWithNibName:nil bundle:nil];
    vc1.tabBarItem.title = @"Hits";
    vc1.tabBarItem.image = [UIImage imageNamed:@"145-persondot.png"];
    vc1.navigationItem.title = @"Hits";
    nc1.viewControllers = [NSArray arrayWithObjects:vc1, nil];
    
    nc2 = [[UINavigationController alloc] init];
    vc2 = [[Favorites alloc] initWithNibName:nil bundle:nil];
    vc2.tabBarItem.title = @"Portfolio";
    vc2.tabBarItem.image = [UIImage imageNamed:@"33-cabinet.png"];
    vc2.navigationItem.title = @"Portfolio";
    nc2.viewControllers = [NSArray arrayWithObjects:vc2, nil];
    
    nc3 = [[UINavigationController alloc] init];
    vc3 = [[NewRequests alloc] initWithNibName:nil bundle:nil];
    vc3.tabBarItem.title = @"Requests";
    vc3.tabBarItem.image = [UIImage imageNamed:nil];
    vc3.navigationItem.title = @"Requests";
    nc3.viewControllers = [NSArray arrayWithObjects:vc3, nil];
    
    nc4 = [[UINavigationController alloc] init];
    vc4 = [[Trending alloc] initWithNibName:nil bundle:nil];
    vc4.tabBarItem.title = @"Trending";
    vc4.tabBarItem.image = [UIImage imageNamed:@"122-stats.png"];
    vc4.navigationItem.title = @"Trending";
    nc4.viewControllers = [NSArray arrayWithObjects:vc4, nil];
    
    nc5 = [[UINavigationController alloc] init];
    vc5 = [[Social alloc] initWithNibName:nil bundle:nil];
    vc5.tabBarItem.title = @"Soc-Evo";
    vc5.tabBarItem.image = [UIImage imageNamed:@"189-plant.png"];
    vc5.navigationItem.title = @"Social-Evolution";
    nc5.viewControllers = [NSArray arrayWithObjects:vc5, nil];

    self.viewControllers = [NSArray arrayWithObjects:nc1, nc2, nc3, nc4, nc5, nil];

    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"cameraTabBarItem.png"] highlightImage:nil];
    
    [self.tabBarController setDelegate:self];

}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"hit");
    
    [self.navigationController popToRootViewControllerAnimated:YES];   
}

/*
-(void)willAppearIn:(UINavigationController *)navigationController
{
    [self addCenterButtonWithImage:[UIImage imageNamed:@"cameraTabBarItem.png"] highlightImage:nil];
}
 */

@end
