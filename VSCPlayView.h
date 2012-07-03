//
//  ViewController.h
//  PodcastPlayer
//
//  Created by Lukas Burgstaller on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VSCPlayView : UIViewController
{
    __weak IBOutlet UINavigationBar *navbar;
    __weak IBOutlet UINavigationItem *navigationItem;

    __weak IBOutlet UIImageView *artwork;
    __weak IBOutlet UIProgressView *position;
    
    __weak IBOutlet UILabel *time;
    
    __weak IBOutlet UIButton *prevButton;
    __weak IBOutlet UIButton *playButton;
    __weak IBOutlet UIButton *nextButton;
    MPMusicPlayerController *player;
}

- (IBAction)close:(id)sender;
- (IBAction)jumpBack:(id)sender;
- (IBAction)jumpAhead:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)toggleTime:(id)sender;

@end
