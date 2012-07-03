//
//  VSCPodcastLibary.h
//  PodcastPlayer
//
//  Created by Lukas Burgstaller on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VSCPodcastLibary : NSObject
{
    NSArray *podcasts;
}

+ (VSCPodcastLibary *)sharedInstance;

- (NSArray *) lists;

- (NSArray *)allPodcasts;
- (NSArray *)allPodcastTitles;
- (NSArray *)podcastsForTitles:(NSArray *)titles;

- (NSInteger)episodesForTitles:(NSArray *)titles;
- (NSInteger)unplayedEpisodesForTitles:(NSArray *)titles;
- (NSArray *)unfinishedEpisodesForTitles:(NSArray *)titles;

@end
