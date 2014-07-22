//
//  HorizontalScroller.m
//  BlueLibrary
//
//  Created by Luke on 22/07/2014.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import "HorizontalScroller.h"

//
//  constants defined for view within the enclosing scroller to simplfiy modification of the layout when designing
//

#define VIEW_PADDING 10
#define VIEW_DIMENSIONS 100
#define VIEWS_OFFSET 100


//
//  HorizontalScroller conforms to the UIScrollViewDelegate protocol
//  HorizontalScroller uses UIScrollView to scroll the album covers
//  HorizontalScroller needs to know user interaction events (i.e. user stops scrolling)
//

@interface HorizontalScroller () <UIScrollViewDelegate>

@end

//  create a scrolling view that contains the album cover views

@implementation HorizontalScroller
{
    UIScrollView *scroller;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scroller.delegate = self;
        [self addSubview:scroller];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapped:)];
        [scroller addGestureRecognizer:tapRecognizer];
    }
    return self;
}

@end
