//
//  LibraryAPI.h
//  BlueLibrary
//
//  Created by Luke on 21/07/2014.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"   // import Data Model (MVC) for album access

// communication logic accessing all services

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

//
//  save the album data each time the app enters the background
//  caters for saving in case album data is later changed
//  main application accesses all services through LibraryAPI to inform PersistencyManager to save album data
//

- (void)saveAlbums;

@end
