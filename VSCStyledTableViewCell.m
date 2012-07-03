//
//  VSCStyledTableViewCell.m
//  Dozzzer
//
//  Created by Lukas Burgstaller on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VSCStyledTableViewCell.h"

@implementation VSCStyledTableViewCell
@synthesize inversed, accessory, centered, allowsDelete, userdata;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        VSCStyledTableCellBackgroundView *bgv = [VSCStyledTableCellBackgroundView new];
        self.backgroundView = bgv;
        bgv = [VSCStyledTableCellBackgroundView new];
        bgv.selected = YES;
        accessory = VSCStyledTableCellAccessoryNone;
        self.selectedBackgroundView = bgv;
        
        self.textLabel.textColor = [UIColor whiteColor];
        
        accessoryView = [UIImageView new];
        [self addSubview:accessoryView];
        
        self.textLabel.font = [UIFont fontWithName:@"Maven Pro" size:16];
        self.detailTextLabel.font = [UIFont fontWithName:@"Maven Pro" size:12];
    }
    return self;
}

#pragma mark - Accessors

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (!deleteButton)
    {
        [super setSelected:selected animated:animated];
    }
    
    
    // Configure the view for the selected state
}

- (void) setInversed:(BOOL)i;
{
    inversed = i;
    ((VSCStyledTableCellBackgroundView *)self.backgroundView).inversed = inversed;
    ((VSCStyledTableCellBackgroundView *)self.selectedBackgroundView).inversed = inversed;
}

#pragma mark - Layout

//- (void) layoutSubviews
//{
//    if (!deleteButton)
//    {
//        [super layoutSubviews];
//    
//        accessoryView.frame = CGRectMake(5, ((self.frame.size.height - accessoryView.image.size.height)/2), accessoryView.image.size.width, accessoryView.image.size.height);
//        
//        if (centered)
//        {
//            self.textLabel.frame = CGRectMake(0, self.textLabel.frame.origin.y, self.frame.size.width, self.textLabel.frame.size.height);
//            self.detailTextLabel.frame = CGRectMake(0, self.detailTextLabel.frame.origin.y, self.frame.size.width, self.detailTextLabel.frame.size.height);
//            
//            self.textLabel.textAlignment = UITextAlignmentCenter;
//            self.detailTextLabel.textAlignment = UITextAlignmentCenter;
//        }
//        else
//        {
//            if (accessory == VSCStyledTableCellAccessoryNone || accessory == VSCStyledTableCellAccessoryPlay)
//            {
//                self.textLabel.frame = CGRectMake(33, self.textLabel.frame.origin.y, self.frame.size.width - 33, self.textLabel.frame.size.height);
//                self.detailTextLabel.frame = CGRectMake(33, self.detailTextLabel.frame.origin.y, self.frame.size.width - 33, self.detailTextLabel.frame.size.height);
//            }
//            else
//            {
//                self.textLabel.frame = CGRectMake(40, self.textLabel.frame.origin.y, self.frame.size.width - 40, self.textLabel.frame.size.height);
//                self.detailTextLabel.frame = CGRectMake(40, self.detailTextLabel.frame.origin.y, self.frame.size.width - 40, self.detailTextLabel.frame.size.height);
//            }
//         }
//    }
//    
//
//    
//    if (allowsDelete && [[self gestureRecognizers] count] == 0)
//    {
//        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(displayDeleteButton)];
//        swipe.direction = UISwipeGestureRecognizerDirectionRight;
//        [self addGestureRecognizer:swipe];
//    }
//}

@end
