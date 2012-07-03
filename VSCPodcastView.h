//
//  VSCPodcastView.h
//  PodcastPlayer
//
//  Created by Lukas Burgstaller on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VSCPodcastView : UIViewController
{
    IBOutlet UIBarButtonItem *playing;
    NSArray *podcasts;
    NSArray *podcastTitles;
    __weak IBOutlet UITableView *tableView;
    __weak IBOutlet UISegmentedControl *segmentCtrl;
}

- (id)initWithPodcastTitles:(NSArray *)titles;
- (IBAction)sortOrderChanged:(id)sender;
- (IBAction)showPlayView:(id)sender;

@end
