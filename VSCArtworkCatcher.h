//
//  VSCArtworkCatcher.h
//  PodcastPlayer
//
//  Created by Lukas Burgstaller on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VSCArtworkCatcher : NSObject
{

}

+ (void) fetchArtworkForPodcast:(MPMediaItem *)podcast forImageView:(UIImageView *)imageView withSize:(CGSize)size;

@end
