//
//  ViewController.m
//  BlueLibrary
//
//  Created by Eli Ganem on 31/7/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//
//  Modified by Luke Schoen in 2014

#import "ViewController.h"

@interface ViewController ()

// private properties not required by other classes
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation ViewController

@synthesize coverImage;
@synthesize indicator;

- (void)viewWillAppear:(BOOL)animated
{
    self.coverImage.backgroundColor = [UIColor redColor];
    self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.indicator startAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
