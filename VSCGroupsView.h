//
//  VSCGroupsView.h
//  PodcastPlayer
//
//  Created by Lukas Burgstaller on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PodcastList.h"

@interface VSCGroupsView : UIViewController
{
    IBOutlet UIBarButtonItem *playingButton;
    __weak IBOutlet UITableView *tableView;
    
    NSArray *groups;
}

- (void) loadCollection;

- (IBAction)showPlayView:(id)sender;

@end
