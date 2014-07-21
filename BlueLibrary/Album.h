//
//  Album.h
//  BlueLibrary
//
//  Created by Luke on 21/07/2014.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject

// properties all read-only as not required to change after creation
@property (nonatomic, copy, readonly) NSString *title, *artist, *genre, *coverUrl, *year;

// method prototype passes album details
- (id)initWithTitle:(NSString*)title artist:(NSString*)artist coverUrl:(NSString*)coverUrl year:(NSString*)year;

@end
