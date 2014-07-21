//
//  LibraryAPI.h
//  BlueLibrary
//
//  Created by Luke on 21/07/2014.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibraryAPI : NSObject

// singleton object entry point to manage all albums

+ (LibraryAPI*)sharedInstance;

@end
