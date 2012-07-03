//
//  VSCStyledTableCellBackgroundView.h
//  Dozzzer
//
//  Created by Lukas Burgstaller on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSCStyledTableCellBackgroundView : UIView
{
    BOOL inversed;
    BOOL selected;
}
@property (readwrite, assign) BOOL inversed;
@property (readwrite, assign) BOOL selected;

@end
