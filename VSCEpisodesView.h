//
//  VSCEpisodesView.h
//  PodcastPlayer
//
//  Created by Lukas Burgstaller on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSCEpisodesView : UIViewController
{
    NSArray *podcasts;
    NSMutableArray *episodes;
    NSArray *podcastTitles;    
    __weak IBOutlet UITableView *tableView;
    __weak IBOutlet UISegmentedControl *segmentCtrl;
    IBOutlet UIBarButtonItem *playingButton;
}

- (id)initWithPodcastTitles:(NSArray *)titles;
- (id)initWithPodcastTitles:(NSArray *)titles unfinished:(BOOL)showOnlyUnfished;

- (IBAction)sortOrderChanged:(id)sender;
- (IBAction)showPlayView:(id)sender;

@end
