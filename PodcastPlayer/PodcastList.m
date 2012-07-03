//
//  Collection.m
//  PodcastPlayer
//
//  Created by Lukas Burgstaller on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PodcastList.h"


@implementation PodcastList
@synthesize title, podcasts;

- (id)init
{
    self = [super init];
    if (self) {
        podcasts = [NSMutableSet new];
    }
    return self;
}

@end
