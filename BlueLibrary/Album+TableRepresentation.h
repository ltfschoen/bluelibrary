//
//  Album+TableRepresentation.h
//  BlueLibrary
//
//  Created by Luke on 22/07/2014.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import "Album.h"

//
//  category (decorator design pattern) that extends the album class
//  avoids subclassing the album class to use its properties directly
//  avoids modifying the album class code
//

@interface Album (TableRepresentation)

- (NSDictionary*)tr_tableRepresentation;    // prefix method name convention

@end
