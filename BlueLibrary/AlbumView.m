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

@end