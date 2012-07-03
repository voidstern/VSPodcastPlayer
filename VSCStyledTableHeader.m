//
//  VSCStyledTableHeader.m
//  Dozzzer
//
//  Created by Lukas Burgstaller on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VSCStyledTableHeader.h"

@implementation VSCStyledTableHeader
@synthesize  textLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        background = [VSCStyledTableCellBackgroundView new];
        background.inversed = YES;
        background.alpha = .8;
        textLabel = [UILabel new];
        textLabel.font = [UIFont fontWithName:@"Maven Pro" size:14];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:background];
        [self addSubview:textLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) layoutSubviews
{
    [super layoutSubviews];
    background.frame = self.bounds;
    textLabel.frame = CGRectMake(10, (self.bounds.size.height - 20) / 2, self.bounds.size.width - 15, 20);
}

@end
