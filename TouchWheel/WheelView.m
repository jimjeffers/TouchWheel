//
//  WheelView.m
//  TouchWheel
//
//  Created by Jim Jeffers on 8/25/12.
//  Copyright (c) 2012 Jim Jeffers. All rights reserved.
//

#import "WheelView.h"

@implementation WheelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width/2, rect.size.height/2)
                                                          radius:rect.size.width/2
                                                      startAngle:0
                                                        endAngle:2*M_PI clockwise:YES];
    
    UIBezierPath *thumbWheel = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width/2, 10+rect.size.width/7)
                                                              radius:rect.size.width/7
                                                          startAngle:0
                                                            endAngle:2*M_PI clockwise:YES];
    
    [circle appendPath:thumbWheel];
    [circle setUsesEvenOddFillRule:YES];
    
    [[UIColor orangeColor] set];
    [circle fill];
}

@end
