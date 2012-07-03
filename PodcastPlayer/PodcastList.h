//
//  Collection.h
//  PodcastPlayer
//
//  Created by Lukas Burgstaller on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PodcastList : NSObject
{
    NSString * title;
    NSMutableSet *podcasts;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, readonly) NSMutableSet *podcasts;

@end
