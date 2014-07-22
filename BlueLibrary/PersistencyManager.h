//
//  PersistencyManager.h
//  BlueLibrary
//
//  Created by Luke on 21/07/2014.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"   // import Data Model (MVC) for album access

@interface PersistencyManager : NSObject

// album data CRUD

- (NSArray*)getAlbums;
- (void)addAlbum:(Album*)album atIndex:(int)index;
- (void)deleteAlbumAtIndex:(int)index;

// album covers CRUD (save album cover images locally)

- (void)saveImage:(UIImage*)image filename:(NSString*)filename;
- (UIImage*)getImage:(NSString*)filename;


@end
