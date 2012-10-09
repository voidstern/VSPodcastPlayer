//
//  ViewController.m
//  PodcastPlayer
//
//  Created by Lukas Burgstaller on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VSCPlayView.h"
#import "VSCArtworkCatcher.h"
#import "MPMediaItemProperties.h"

@interface VSCPlayView ()

@end

@implementation VSCPlayView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        player = [MPMusicPlayerController iPodMusicPlayer];
        [player beginGeneratingPlaybackNotifications];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                               selector:@selector(handlePlaybackChanged:)
                                   name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification 
                                 object:player];
        // Custom initialization
    }
    return self;
}

- (void) handlePlaybackChanged:(NSNotification *)notification
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) updatePosition
{
    position.progress = player.currentPlaybackTime / player.nowPlayingItem.playbackDuration;
    int c_min = floorl((player.currentPlaybackTime)/60);
    int c_sec = player.currentPlaybackTime - c_min * 60;
    int d_min = floorl((player.nowPlayingItem.playbackDuration)/60);
    int d_sec = player.nowPlayingItem.playbackDuration - d_min * 60;
    
    time.text = [NSString stringWithFormat:@"%d:%02d / %d:%02d", c_min, c_sec, d_min, d_sec];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [VSCArtworkCatcher fetchArtworkForPodcast:[player nowPlayingItem] forImageView:artwork withSize:CGSizeMake(640, 640)];
    
    if ([player playbackState] == MPMusicPlaybackStatePlaying) 
    {
        playButton.selected = YES;
    }
    else 
    {
        playButton.selected = NO;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updatePosition) userInfo:nil repeats:YES];
    
    time.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    artwork = nil;
    playButton = nil;
    nextButton = nil;
    prevButton = nil;
    position = nil;
    time = nil;
    navigationItem = nil;
    navbar = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewWillAppear:(BOOL)animated
{
    [self updatePosition];
}

- (IBAction)close:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)jumpBack:(id)sender 
{
    player.currentPlaybackTime = player.currentPlaybackTime - 30;
}

- (IBAction)jumpAhead:(id)sender 
{
    player.currentPlaybackTime = player.currentPlaybackTime + 60;
}

- (IBAction)play:(id)sender 
{
    if ([player playbackState] == MPMusicPlaybackStatePlaying) 
    {
        [player pause];
        playButton.selected = NO;
    }
    else 
    {
        [player play];
        playButton.selected = YES;
    }
}

- (IBAction)toggleTime:(id)sender 
{
    time.hidden = ! time.hidden;
}

@end
