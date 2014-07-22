//
//  HorizontalScroller.h
//  BlueLibrary
//
//  Created by Luke on 22/07/2014.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import <UIKit/UIKit.h>

//
//  refer to new delegate in class definition. protocol is now visible at this point
//  use forward declaration of the protocol so Xcode and compiler know it will be available
//

@protocol HorizontalScrollerDelegate;

@interface HorizontalScroller : UIView

    //
    // property with weak pointer to its delegate to prevent a strong reference retain cycle
    // (where the delegate keeps a strong pointer back to the conforming class that has a strong pointer to the delegate as well)
    // resulting in memory leak since neither class will release the memory allocated to each other
    //
    // use 'id' type for type safety (delegate can only be assigned classes conforming to HorizontalScrollerDelegate
    //

    @property (weak) id<HorizontalScrollerDelegate> delegate;

    //
    // reload method modelled after reloadData in UITableView. it reloads all the data used to construct the horizontal scroller.
    //

    - (void)reload;

@end

//
//  protocol conforms to inherited NSObject protocol is best practice
//  and enables sending of messages defined by NSObject to the
//  HorizontalScroller Delegate
//

@protocol HorizontalScrollerDelegate <NSObject>

    //
    //  define the required and optional methods for the delegate to implement
    //

    @required

    // number of views (ask delegate how many views want to present inside horizontal scroller)
    - (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScroller*)scroller;

    // view at specific index (ask delegate to return the view that should appear at <index>)
    - (UIView*)horizontalScroller:(HorizontalScroller*)scroller viewAtIndex:(int)index;

    // behaviour when tapped (inform delegate which view at <index> has been clicked)
    - (void)horizontalScroller:(HorizontalScroller*)scroller clickedViewAtIndex:(int)index;

    @optional

    // initial view (ask delegate for index of initial view to display. this method is optional
    // and defaults to 0 if it is not implemented by the delegate)
    - (NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller*)scroller;

@end