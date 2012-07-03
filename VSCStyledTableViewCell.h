//
//  VSCStyledTableViewCell.h
//  Dozzzer
//
//  Created by Lukas Burgstaller on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSCStyledTableCellBackgroundView.h"

typedef enum {
    VSCStyledTableCellAccessoryNone,
    VSCStyledTableCellAccessoryPlay,
    VSCStyledTableCellAccessoryUnselected,
    VSCStyledTableCellAccessorySelected
} VSCStyledTableCellAccessory;

@interface VSCStyledTableViewCell : UITableViewCell
{
    BOOL inversed;
    BOOL centered;
    BOOL allowsDelete;
    
    VSCStyledTableCellAccessory accessory;
    
    id userdata;
    UIImageView *accessoryView;
    UIButton *deleteButton;
    UITapGestureRecognizer *tap;
}
@property (readwrite, assign, nonatomic) VSCStyledTableCellAccessory accessory;
@property (readwrite, assign, nonatomic) BOOL inversed;
@property (readwrite, assign, nonatomic) BOOL centered;
@property (readwrite, assign, nonatomic) BOOL allowsDelete;
@property (readwrite, retain) id userdata;
@end
