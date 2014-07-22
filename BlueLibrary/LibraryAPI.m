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

#pragma mark - remove observer from notifications

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - singleton API

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

#pragma mark - album cover download

//
//  notifications cause method execution
//  notification object received by method as a parameter
//

- (void)downloadImage:(NSNotification*)notification
{
    //
    //  UIImageView and album cover image URL retrieved from the notification
    //
    
    UIImageView *imageView = notification.userInfo[@"imageView"];
    NSString *coverUrl = notification.userInfo[@"coverUrl"];
    
    //
    //  image is retrieved locally (if previously downloaded) from the PersistencyManager
    //
    
    imageView.image = [persistencyManager getImage:[coverUrl lastPathComponent]];
    
    //
    //  image retrieved from external URL (if not previously downloaded) using HTTPClient
    //
    
    if (imageView.image == nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage *image = [httpClient downloadImage:coverUrl];
            
            //
            //  download completion triggers
            //  - image display in image view
            //  - saved locally using PersistencyManager
            //
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                imageView.image = image;
                [persistencyManager saveImage:image filename:[coverUrl lastPathComponent]];
            });
        });
    }    
}

@end
