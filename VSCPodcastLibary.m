//
//  VSCPodcastLibary.m
//  PodcastPlayer
//
//  Created by Lukas Burgstaller on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VSCPodcastLibary.h"
#import "MPMediaItemProperties.h"
#import "PodcastList.h"

@interface MPMediaItem (Private)

-(double) stopTime;
-(double) startTime;
-(NSString *) artist;
-(BOOL) hasBeenPlayed;

@end

@implementation VSCPodcastLibary

+ (VSCPodcastLibary *)sharedInstance
{
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred, ^{ shared = [[self alloc] init]; });
    return shared;
}

- (id)init {
    self = [super init];
    if (self) 
    {
        MPMediaQuery *query = [MPMediaQuery podcastsQuery];
        [query setGroupingType:MPMediaGroupingPodcastTitle];
        podcasts = [query collections];
    }
    return self;
}

#pragma mark - Playlists

- (NSArray *) lists
{
    NSMutableArray *lists = [NSMutableArray new];
    MPMediaQuery *query = [MPMediaQuery playlistsQuery];
    
    for (MPMediaPlaylist *playlist in [query collections])
    {
        if ([[[playlist representativeItem] valueForProperty:MPMediaItemPropertyMediaType] intValue] == 2) 
        {
            PodcastList *list = [PodcastList new];
            list.title = [playlist valueForProperty: MPMediaPlaylistPropertyName];
            for (MPMediaItem *item in [playlist items]) 
            {
                [list.podcasts addObject:[item podcastTitle]];
            }
            
            [lists addObject:list];
        }
    }
    
    return lists;
}

#pragma mark - Podcasts

- (NSArray *)allPodcasts
{
    return podcasts;
}

- (NSArray *)allPodcastTitles
{
    NSMutableArray *podcastTitles = [NSMutableArray new];
    
    for (MPMediaItemCollection *item in podcasts) 
    {
        [podcastTitles addObject:[[item representativeItem] podcastTitle]];
    }
    
    return podcastTitles;
}

- (NSArray *)podcastsForTitles:(NSArray *)titles
{
    NSMutableArray *filteredPodcasts = [NSMutableArray new];
    
    for (NSString *title in titles)
    {
        MPMediaQuery *query = [MPMediaQuery podcastsQuery];
        [query setGroupingType:MPMediaGroupingPodcastTitle];
        MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue: title forProperty: MPMediaItemPropertyPodcastTitle];
        [query addFilterPredicate:predicate];
        [filteredPodcasts addObjectsFromArray:[query collections]];
    }

    return filteredPodcasts;
}

- (NSInteger)episodesForTitles:(NSArray *)titles
{
    NSInteger episodes = 0;
    
    for (NSString *title in titles)
    {
        MPMediaQuery *query = [MPMediaQuery podcastsQuery];
        [query setGroupingType:MPMediaGroupingPodcastTitle];
        MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue: title forProperty: MPMediaItemPropertyPodcastTitle];
        [query addFilterPredicate:predicate];
        
        for (MPMediaItemCollection *collection in [query collections]) 
        {
            episodes = episodes + [collection count];
        }
    }
    
    return episodes;
}

- (NSInteger)unplayedEpisodesForTitles:(NSArray *)titles
{
    NSInteger episodes = 0;
    
    for (NSString *title in titles)
    {
        MPMediaQuery *query = [MPMediaQuery podcastsQuery];
        [query setGroupingType:MPMediaGroupingPodcastTitle];
        MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue: title forProperty: MPMediaItemPropertyPodcastTitle];
        [query addFilterPredicate:predicate];
        
        for (MPMediaItemCollection *collection in [query collections]) 
        {
            for (MPMediaItem *item in [collection items])
            {
                if ([item playCount] == 0)
                {
                    episodes ++;
                }
            }
        }
    }
    
    return episodes;
}

- (NSArray *)unfinishedEpisodesForTitles:(NSArray *)titles
{
    NSMutableArray *episodes = [NSMutableArray new];
    
    for (NSString *title in titles)
    {
        MPMediaQuery *query = [MPMediaQuery podcastsQuery];
        [query setGroupingType:MPMediaGroupingPodcastTitle];
        MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue: title forProperty: MPMediaItemPropertyPodcastTitle];
        [query addFilterPredicate:predicate];
        
        for (MPMediaItemCollection *collection in [query collections]) 
        {
            for (MPMediaItem *item in [collection items])
            {
                NSLog(@"%@: %d, %d", [item title], [item playCount], [item hasBeenPlayed]);
                
                if ([item playCount] == 0 && [item hasBeenPlayed]) 
                {
                    [episodes addObject:item];
                }
            }
        }
    }
    
    return episodes;
}


@end
