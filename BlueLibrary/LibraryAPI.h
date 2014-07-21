//
//  LibraryAPI.h
//  BlueLibrary
//
//  Created by Luke on 21/07/2014.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"   // import Data Model (MVC) for album access

@interface LibraryAPI : NSObject

//
//  exposed singleton object entry point portal API
//  uses facade design pattern to hide complex system
//  logic of underlying classes
//

+ (LibraryAPI*)sharedInstance;

//
//  methods hidden under the facade design pattern
//  only their prototype is exposed to other classes
//

- (NSArray*)getAlbums;
- (void)addAlbum:(Album*)album atIndex:(int)index;
- (void)deleteAlbumAtIndex:(int)index;

@end
