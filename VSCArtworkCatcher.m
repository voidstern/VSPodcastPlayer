//
//  VSCArtworkCatcher.m
//  PodcastPlayer
//
//  Created by Lukas Burgstaller on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VSCArtworkCatcher.h"

@implementation VSCArtworkCatcher

+ (void) fetchArtworkForPodcast:(MPMediaItem *)podcast forImageView:(UIImageView *)imageView withSize:(CGSize)size
{        
    
    imageView.image = [UIImage imageNamed:@"CoverArt"];
    
    dispatch_async(dispatch_queue_create("fetch", DISPATCH_QUEUE_SERIAL), ^{    
        
        MPMediaItemArtwork *artwork = [podcast valueForProperty: MPMediaItemPropertyArtwork];
        UIImage *art;
        
        if (artwork) 
        {
            art = [artwork imageWithSize:size];
        }
        
        if (art) 
        {
            if (CGSizeEqualToSize(art.size, size)) 
            {
                dispatch_sync(dispatch_get_main_queue(), ^{  
                    imageView.image = art;
                });
            }
            else {
                UIGraphicsBeginImageContext(size);
                [art drawInRect:CGRectMake(0, 0, size.width, size.height)];
                art = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                dispatch_sync(dispatch_get_main_queue(), ^{  
                    imageView.image = art;
                });
            }
        }
    });  
}



@end
