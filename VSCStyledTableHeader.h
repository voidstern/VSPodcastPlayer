//
//  VSCStyledTableHeader.h
//  Dozzzer
//
//  Created by Lukas Burgstaller on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSCStyledTableCellBackgroundView.h"

@interface VSCStyledTableHeader : UIView
{
    VSCStyledTableCellBackgroundView *background;
    UILabel *textLabel;
}
@property (readonly) UILabel *textLabel;

@end
