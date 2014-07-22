//
//  LibraryAPI.m
//  BlueLibrary
//
//  Created by Luke on 21/07/2014.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import "LibraryAPI.h"

#import "PersistencyManager.h"  // import classes hidden under facade design pattern
#import "HTTPClient.h"

@interface LibraryAPI () {
    
    //
    //  declare private variables using a class extension
    //
    
    PersistencyManager *persistencyManager;
    HTTPClient *httpClient;
    BOOL isOnline;  // update server with album list changes
}

@end

@implementation LibraryAPI

//
//  initialise private variable
//

- (id)init
{
    self = [super init];
    if (self) {
        persistencyManager = [[PersistencyManager alloc] init];
        httpClient = [[HTTPClient alloc] init];
        isOnline = NO;  // sample app not dealing with real server. fixed value of 'NO'
        
        //
        //  observer of notifications (i.e. from AlbumView).
        //  - LibraryAPI is registered as an observer for 'BLDownloadImageNotification'
        //  - AlbumView class posts BLDownloadImageNotification notifications
        //  the system notifies LibraryAPI of each notification posted
        //  and in response LibraryAPI executes 'downloadImage:' method
        //
        //  'dealloc' method unsubscribes the observing class from notifications it registered
        //  for to prevent crashes that would otherwise be caused by notifications being send
        //  to an deallocated instance
        //
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadImage:) name:@"BLDownloadImageNotification" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (LibraryAPI*)sharedInstance
{
    //
    //  declare static variable to hold instance of class
    //  ensures its availability in this class
    //
    
    static LibraryAPI *_sharedInstance = nil;
    
    //
    //  declare static variable 'dispatch_once_t'
    //  ensures initialisation code executes only once
    //
    
    static dispatch_once_t oncePredicate;
    
    //
    //  use Grand Central Dispatch (GCD) to execute block
    //  initialise instance of LibraryAPI class. not called again
    //
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - album CRUD interface convention

//
//  read album
//

- (NSArray*)getAlbums
{
    return [persistencyManager getAlbums];
}

//
//  create album
//

- (void)addAlbum:(Album*)album atIndex:(int)index
{
    //
    //  update data locally
    //
    
    [persistencyManager addAlbum:album atIndex:index];
    
    //
    //  check for internet connection before updating remote server
    //
    
    if (isOnline)
    {
        [httpClient postRequest:@"/api/addAlbum" body:[album description]];
    }
}

//
//  destroy album
//

- (void)deleteAlbumAtIndex:(int)index
{
    [persistencyManager deleteAlbumAtIndex:index];
    
    if (isOnline)
    {
        [httpClient postRequest:@"/api/deleteAlbum" body:[@(index) description]];
    }
}

@end
