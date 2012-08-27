//
//  TouchWheelView.m
//  TouchWheel
//
//  Created by Jim Jeffers on 8/25/12.
//  Copyright (c) 2012 Jim Jeffers. All rights reserved.
//

#import "Math.h"
#import "WheelView.h"
#import "TouchWheelView.h"

@implementation TouchWheelView

@synthesize delegate = __delegate;
@synthesize wheel;
@synthesize clockwise;

# pragma mark - Initializers

// Create a touch wheel using the default "WheelView" as the
// touch UI element to be drawn with a specified radius at a
// supplied center point.

- (id)initWithRadius:(float)radius atCenterPoint:(CGPoint)point {
    CGRect frame = CGRectMake(point.x, point.y, radius*2, radius*2);
    return [self initWithFrame:frame];
}

// Create a touch wheel using a presupplied UIView (or subclass)
// as the UI element.

- (id)initWithView:(UIView *)view {
    // Generate the frame and origin from an existing view.
    CGRect frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.bounds.size.width, view.bounds.size.height);
    
    // Set the passed in view as the wheel and reset its origin.
    wheel = view;
    [wheel setFrame: CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
    
    // Perform the initialization with the expected frame.
    return [self initWithFrame:frame];
}


// General init with frame override.

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panRecognizer];
        
        // Use the default wheel if a view for the wheel has not already been set.
        if (wheel == nil) {
            wheel = [[WheelView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        }
        [self addSubview:wheel];
        
        lastAngle = 0;
    }
    return self;
}

# pragma mark - Gestures

-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    // The current location of the touch in the view will
    // be used to determine the angle of rotation compared
    // against the center of the view. - JJ
    
    CGPoint location = [recognizer locationInView:self];
    
    // We'l use the center point of the view to calculate
    // the angle between the current location of the pan
    // and the center of the wheel. We'll also use this
    // to mutate the angle (stored in 'radians') depending
    // on which horizontal half of the circle the user is
    // currently panning in. - JJ
    
    float centerX = recognizer.view.bounds.size.width/2;
    float centerY = recognizer.view.bounds.size.height/2;
    
    CGPoint centerPoint = CGPointMake(centerX, centerY);
    
    // We'll determine whether or not the movement is
    // clockwise by checking the translation of the gesture,
    // which is effectively the delta, and the location
    // of the gesture. If we are above the center of the circle
    // and moving in a negative X direction or conversely
    // if we are moving in a positive direction when below
    // the vertical center of the view, then we know we're
    // moving in a clockwise manner. - JJ
    
    CGPoint translation = [recognizer translationInView:self];
    if (translation.x != 0) {
        BOOL lastDirection = clockwise;
        clockwise = ((location.y > centerY && translation.x > 0) || (location.y < centerY && translation.x < 0)) ? YES : NO;
        if (clockwise != lastDirection) {
            if ([__delegate respondsToSelector:@selector(touchWheelView:didChangeDirection:)]) {
                [__delegate touchWheelView:self didChangeDirection:clockwise];
            }
        }
    }
    
    // Here we actually calculate the angle between the two
    // points. - JJ

    CGFloat radians = angleBetweenPoints(location, centerPoint);
    
    // Adding PI to the angle allows us to perform a full
    // rotation as the user rotates around the alternate
    // half of the wheel. When the user crosses over from
    // the left half of the wheel to the right half our angle
    // behaves as such:
    //
    // 1.49, 1.51, 1.53, 1.56 |X| -1.55, -1.53, -1.52
    //
    // So by adding the full value of PI after crossing we
    // get the behavior of a full rotation:
    //
    // 1.49, 1.51, 1.53, 1.56 |X| 1.57, 1.59, 1.61, etc...
    //
    // - JJ
    
    if (location.x > centerX) {
        radians += M_PI;
    }
    
    // We'll use the delta in the angle to determine whether or
    // not we experienced a bad outcome from our gesture input.
    // A bad outcome usually involves the position of the users
    // touch to return an angle that doesn't match the path
    // of the movement we expected. This typically involves the
    // angle inverting. To work around this we simply do not
    // perform the translation when the ABS of the delta exceeds
    // a value of 1. - JJ
    
    float changeInAngle = lastAngle - radians;
    if (abs(changeInAngle) < 1) {
        wheel.transform = CGAffineTransformMakeRotation(-radians);
    }
    
    // Reset translation and update the lastAngle to the angle
    // we just used.
    
    lastAngle = radians;
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
}

# pragma mark - Point Trigonometry

// Angle calculation convenience method is from Jeff Lamarche's
// handy-dandy post which can be found at:
// http://iphonedevelopment.blogspot.com/2008/10/couple-more-math-snippets-for-2d.html

CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
    CGFloat height = second.y - first.y;
    CGFloat width = first.x - second.x;
    CGFloat rads = atan(height/width);
    return rads;
}

@end
