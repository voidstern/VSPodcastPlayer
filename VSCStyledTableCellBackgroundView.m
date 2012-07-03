//
//  VSCStyledTableCellBackgroundView.m
//  Dozzzer
//
//  Created by Lukas Burgstaller on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VSCStyledTableCellBackgroundView.h"

@implementation VSCStyledTableCellBackgroundView
@synthesize inversed, selected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw Gradient
    
    CGColorRef lightColor = [UIColor colorWithRed:0.737 green:0.757 blue:0.780 alpha:1.].CGColor;
    CGColorRef darkColor = [UIColor colorWithRed:0.678 green:0.702 blue:0.725 alpha:1.].CGColor;
    
    NSArray *colors;
    
    if (!inversed)
    {
        colors = [NSArray arrayWithObjects:(id)darkColor, (id)lightColor, nil];
    }
    else
    {
        colors = [NSArray arrayWithObjects:(id)lightColor, (id)darkColor, nil];
    }
    
    CGGradientRef gradient = CGGradientCreateWithColors(NULL, (CFArrayRef)colors, NULL);
    
    CGContextSetRGBStrokeColor(ctx, 255, 255, 225, 0.0);
    CGContextSetLineWidth(ctx, 1.0);
    
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, self.bounds.size.height + self.bounds.origin.y), CGPointMake(0, 0), 0);
    
    if (selected)
    {
        CGContextSetFillColorWithColor(ctx, [[UIColor colorWithHue:0.000 saturation:0.000 brightness:0.0 alpha:0.33] CGColor]);
        CGContextFillRect(ctx, rect);
    }
    else
    {
        // Draw Highlight
        
        CGContextSetRGBStrokeColor(ctx, 255, 255, 255, 0.2);
        CGContextSetLineWidth(ctx, 1.0);
        
        CGContextMoveToPoint(ctx, 0.0, 0.0);
        CGContextAddLineToPoint(ctx, self.bounds.size.width, 0.0);
        
        CGContextStrokePath(ctx);
        
        // Draw Shadow
        
        CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 0.5);
        CGContextSetLineWidth(ctx, 1.0);
        
        CGContextMoveToPoint(ctx, 0.0, self.bounds.size.height);
        CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
        
        CGContextStrokePath(ctx);
    }
    

}


@end
