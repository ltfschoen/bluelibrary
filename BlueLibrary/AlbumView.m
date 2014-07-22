//
//  AlbumView.m
//  BlueLibrary
//
//  Created by Luke on 22/07/2014.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import "AlbumView.h"

@implementation AlbumView
{
    // private properties not required by other classes
    
    UIImageView *coverImage;
    UIActivityIndicatorView *indicator;
}

- (id)initWithFrame:(CGRect)frame albumCover:(NSString*)albumCover
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.backgroundColor = [UIColor blackColor];
        
        //
        // the coverImage has a 5 pixel margin from its frame
        //
        
        coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-10)];
        [self addSubview:coverImage];
        
        indicator = [[UIActivityIndicatorView alloc] init];
        indicator.center = self.center;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [indicator startAnimating];
        [self addSubview:indicator];
        
        //
        //  KVO pattern - add the current class as an observer for the 'image' property of album coverImage
        //
        
        [coverImage addObserver:self forKeyPath:@"image" options:0 context:nil];
        
        //
        //  perform album cover image download task
        //  notification sent through NSNotificationCenter singleton
        //  contains UIImageView to populate URL and cover image to be downloaded
        //
        
        [[NSNotificationCenter defaultCenter]
            postNotificationName:@"BLDownloadImageNotification"
            object:self
            userInfo:@{@"imageView":coverImage, @"coverUrl":albumCover}];
    }
    return self;
}

//
//  observer implemented in all classes acting as an observer.
//  the system executes this method each time the observed property changes
//

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"image"])
    {
        [indicator stopAnimating];
    }
}

//
//  unregister the KVO observer when it has downloaded
//

- (void)dealloc
{
    [coverImage removeObserver:self forKeyPath:@"image"];
}

@end