//
//  PersistencyManager.h
//  BlueLibrary
//
//  Created by Luke on 21/07/2014.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"   // import the Data Model (MVC)

@interface PersistencyManager : NSObject

// prototype methods to handle album data

- (NSArray*)getAlbums;
- (void)addAlbum:(Album*)album atIndex:(int)index;
- (void)deleteAlbumAtIndex:(int)index;

@end
