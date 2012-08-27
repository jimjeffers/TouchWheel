//
//  TouchWheelView.h
//  TouchWheel
//
//  Created by Jim Jeffers on 8/25/12.
//  Copyright (c) 2012 Jim Jeffers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchWheelView;

#pragma mark - Protocol

@protocol TouchWheelDelegate <NSObject>

@optional
- (void)touchWheelView:(TouchWheelView *)touchWheelView didChangeDirection:(BOOL)clockwise;

@end

#pragma mark - Interface

@interface TouchWheelView : UIView {
    float lastAngle;
    BOOL inverted;
}

@property (nonatomic, weak)     id <TouchWheelDelegate> delegate;
@property (nonatomic, strong)   UIView *wheel;
@property (nonatomic, readonly) BOOL clockwise;

- (id)initWithRadius:(float)radius atCenterPoint:(CGPoint)point;
- (id)initWithView:(UIView *)view;

@end
