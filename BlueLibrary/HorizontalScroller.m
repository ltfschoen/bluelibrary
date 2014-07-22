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

# pragma mark - Initialize Scroll View in Horizontal Scroller

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //
        //  scroll view that completely fills the HorizontalScroller
        //
        
        scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scroller.backgroundColor = [UIColor greenColor];
        scroller.delegate = self;
        [self addSubview:scroller];
        
        //
        //  detect touches on scroll view. check if album cover tap using UITapGestureRecognizer
        //  notify HorizontalScroller Delegate if detected
        //
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapped:)];
        [scroller addGestureRecognizer:tapRecognizer];
    }
    return self;
}

# pragma mark - Gesture Recognition - Detect Scroll View that was Tapped

- (void)scrollerTapped:(UITapGestureRecognizer*)gesture
{
    //
    //  gesture passed as parameter allows extract location of tap using locationInView: method
    //
    
    CGPoint location = [gesture locationInView:gesture.view];
    
    //
    //  loop through each view in the scroll view to find view that was tapped
    //  perform a hit test on each view using CGRectContainsPoint
    //  when found view send the delegate the horizontalScroller:clickedViewAtIndex: message
    //  before finishing center the tapped view in the scroll view
    //
    //  find amount of views by invoking numberofViewsForHorizontalScroller: method on delegate
    //  HorizontalScroller instance has no info about delegate other than messaging it since
    //  delegate must conform to HorizontalScrollerDelegate protocol.
    //  unable to use enumerator as do not want to enumerate over all UIScrollView Subviews
    //  only want to enumerate the subviews we added
    //
    
    for (int index=0; index<[self.delegate numberOfViewsForHorizontalScroller:self]; index++)
    {
        UIView *view = scroller.subviews[index];
        if (CGRectContainsPoint(view.frame, location))
        {
            [self.delegate horizontalScroller:self clickedViewAtIndex:index];
            [scroller setContentOffset:CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0) animated:YES];
            break;
        }
    }
}

# pragma mark - Gesture Recognition - Detect User Finished Dragging inside Scroll View

//
//  informs delegate when user finishes dragging to center the scroll view
//  decelerate parameter is true if scroll view not completely stopped
//

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self centerCurrentView];
    }
}

//
//  called by system when scroll action ends. center the current view
//

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self centerCurrentView];
}

# pragma mark - Centre Album being Viewed inside Scroll View

//
//  check that album being viewed is always centered inside scroll view
//  achieved by perform calculations when user drags scroll view with their finger
//  it calculates distance of current view from center.
//  once centered inform delegate that selected view has changed
//

- (void)centerCurrentView
{
    int xFinal = scroller.contentOffset.x + (VIEWS_OFFSET/2) + VIEW_PADDING;
    int viewIndex = xFinal / (VIEW_DIMENSIONS+(2*VIEW_PADDING));
    xFinal = viewIndex * (VIEW_DIMENSIONS+(2*VIEW_PADDING));
    [scroller setContentOffset:CGPointMake(xFinal,0) animated:YES];
    [self.delegate horizontalScroller:self clickedViewAtIndex:viewIndex];
}

# pragma mark - Reload Scroll View when Data Changes or Move to Another View

//
//  reload method called when add HorizontalScroller to another view
//

- (void)didMoveToSuperview
{
    [self reload];
}

//
//  reload scroller when data changes.
//

- (void)reload
{
    //
    //  check if delegate exists that we can load
    //
    
    if (self.delegate == nil) return;
    
    //
    //  remove all subviews previously added to scroll view
    //
    
    [scroller.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    //
    //  position all views starting from from given offset inside the scroll view
    //
    
    CGFloat xValue = VIEWS_OFFSET;
    
    //
    //  HorizontalScroller adds views by messaging its delegate for its views one at a time.
    //  HorizontalScroller lays views next to each other with predefined padding
    //
    
    for (int i=0; i<[self.delegate numberOfViewsForHorizontalScroller:self]; i++)
    {
        xValue += VIEW_PADDING;
        UIView *view = [self.delegate horizontalScroller:self viewAtIndex:i];
        view.frame = CGRectMake(xValue, VIEW_PADDING, VIEW_DIMENSIONS, VIEW_DIMENSIONS);
        [scroller addSubview:view];
        xValue += VIEW_DIMENSIONS+VIEW_PADDING;
    }
    
    //
    //  all views in place. set content offset for scroll view to allow album cover scrolling
    //
    
    [scroller setContentSize:CGSizeMake(xValue+VIEWS_OFFSET, self.frame.size.height)];
    
    //
    //  HorizontalScroller checks if its delegate responds to selector
    //  initialViewIndexForHorizontalScroller: (optional protocol method)
    //  and uses default value of 0 if delegate does not implement this method
    //  then finally sets scroll view to center initial view defined by delegate
    //
    
    if ([self.delegate respondsToSelector:@selector(initialViewIndexForHorizontalScroller:)])
    {
        int initialView = [self.delegate initialViewIndexForHorizontalScroller:self];
        [scroller setContentOffset:CGPointMake(initialView*(VIEW_DIMENSIONS+(2*VIEW_PADDING)), 0) animated:YES];
    }
}


@end
