//
//  ViewController.m
//  TouchWheel
//
//  Created by Jim Jeffers on 8/25/12.
//  Copyright (c) 2012 Jim Jeffers. All rights reserved.
//

#import "TouchWheelView.h"
#import "ViewController.h"

@interface ViewController () {
    TouchWheelView *touchWheel;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    touchWheel = [[TouchWheelView alloc] initWithRadius:150 atCenterPoint:CGPointMake(0.0, 0.0)];
    touchWheel.delegate = self;
    [self.view addSubview:touchWheel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [touchWheel removeFromSuperview];
    touchWheel = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    touchWheel.center = CGPointMake(self.view.center.x, self.view.center.y);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)touchWheelView:(TouchWheelView *)touchWheelView didChangeDirection:(BOOL)clockwise {
    NSLog(@"Direction: %@",(clockwise ? @"Clockwise" : @"Counter"));
}

@end
