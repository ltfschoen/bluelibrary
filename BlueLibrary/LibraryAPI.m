//
//  LibraryAPI.m
//  BlueLibrary
//
//  Created by Luke on 21/07/2014.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import "LibraryAPI.h"

@implementation LibraryAPI

+ (LibraryAPI*)sharedInstance
{
    // declare static variable to hold instance of class
    // ensures its availability in this class
    
    static LibraryAPI *_sharedInstance = nil;
    
    // declare static variable 'dispatch_once_t'
    // ensures initialisation code executes only once
    
    static dispatch_once_t oncePredicate;
    
    // use Grand Central Dispatch (GCD) to execute block
    // initialise instance of LibraryAPI class. not called again
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    return _sharedInstance;
}

@end
