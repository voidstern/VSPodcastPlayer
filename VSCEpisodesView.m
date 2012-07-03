//
//  VSCEpisodesView.m
//  PodcastPlayer
//
//  Created by Lukas Burgstaller on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VSCEpisodesView.h"
#import "VSCPodcastLibary.h"
#import "VSCArtworkCatcher.h"
#import "MPMediaItemProperties.h"
#import "VSCStyledTableViewCell.h"
#import "VSCPlayView.h"

@implementation VSCEpisodesView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPodcastTitles:(NSArray *)titles
{
    return [self initWithPodcastTitles:titles unfinished:NO];
}

- (id)initWithPodcastTitles:(NSArray *)titles unfinished:(BOOL)showOnlyUnfished
{
    self = [super init];
    if (self) 
    {
        if (showOnlyUnfished) 
        {
            
            episodes = [[[VSCPodcastLibary sharedInstance] unfinishedEpisodesForTitles:titles] mutableCopy];
        }
        else 
        {
            podcasts = [[VSCPodcastLibary sharedInstance] podcastsForTitles:titles];
            episodes = [NSMutableArray new];
            for (MPMediaItemCollection *podcast in podcasts)
            {
                [episodes addObjectsFromArray:[podcast items]];
            }
        }
        
        podcastTitles = titles;
    }
    return self;    
}

- (IBAction)sortOrderChanged:(id)sender
{
    if (segmentCtrl.selectedSegmentIndex == 0) // Sort Unplayed
    {
        NSComparisonResult (^sortBlock)(id, id) = ^(id obj1, id obj2) 
        {
            if ([[obj1 valueForProperty:MPMediaItemPropertyReleaseDate] timeIntervalSince1970] > [[obj2 valueForProperty:MPMediaItemPropertyReleaseDate] timeIntervalSince1970]) 
            { 
                return (NSComparisonResult)NSOrderedAscending;
            }
            if ([[obj1 valueForProperty:MPMediaItemPropertyReleaseDate] timeIntervalSince1970] < [[obj2 valueForProperty:MPMediaItemPropertyReleaseDate] timeIntervalSince1970]) 
            {
                return (NSComparisonResult)NSOrderedDescending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        
        episodes = [[episodes sortedArrayUsingComparator:sortBlock] mutableCopy];
    }
    else if (segmentCtrl.selectedSegmentIndex == 1) // Sort Episodes
    {
        NSComparisonResult (^sortBlock)(id, id) = ^(id obj1, id obj2) 
        {
            if ([[obj1 valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue] > [[obj2 valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue]) 
            { 
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([[obj1 valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue] < [[obj2 valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue]) 
            {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        
        episodes = [[episodes sortedArrayUsingComparator:sortBlock] mutableCopy];
    }
    else // Sort Date
    {
        NSComparisonResult (^sortBlock)(id, id) = ^(id obj1, id obj2) 
        {
            return [[obj1 valueForProperty:MPMediaItemPropertyPodcastTitle] compare:[obj2 valueForProperty:MPMediaItemPropertyPodcastTitle] options:NSCaseInsensitiveSearch];
        };
        
        episodes = [[episodes sortedArrayUsingComparator:sortBlock] mutableCopy];
    }
    
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewDidAppear:(BOOL)animated
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = playingButton;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)showPlayView:(id)sender 
{
    VSCPlayView *play = [VSCPlayView new];
    [self presentModalViewController:play animated:YES];
}

- (void)viewDidUnload
{
    tableView = nil;
    playingButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [episodes count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundView = [UIView new];
    }
    
    cell.textLabel.text = [[episodes objectAtIndex:[indexPath row]] title];
    
    if ([[episodes objectAtIndex:[indexPath row]] playCount] == 0) 
    {
        cell.imageView.alpha = 1;
        cell.detailTextLabel.alpha = 1;
        cell.textLabel.alpha = 1;
    }
    else {
        cell.imageView.alpha = 0.5;
        cell.detailTextLabel.alpha = 0.25;
        cell.textLabel.alpha = 0.25;
    }
    
    if (segmentCtrl.selectedSegmentIndex == 0) // Sort Unplayed
    {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"d. MMMM Y"];
        NSString *formatedDate = [dateFormatter stringFromDate:[[episodes objectAtIndex:[indexPath row]] valueForProperty:MPMediaItemPropertyReleaseDate]];
        
        cell.detailTextLabel.text = formatedDate;
    }
    else if (segmentCtrl.selectedSegmentIndex == 1) // Sort Episodes
    {   
        double duration = [[[episodes objectAtIndex:[indexPath row]] valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
        int hours = floorl(duration/3600);
        int minutes = floorl((duration - hours * 3600)/60);
        int sec = duration - minutes * 60 - hours * 3600;
        if (hours == 0)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, sec];
        }
        else {
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d:%02d:%02d", hours, minutes, sec];
        }
    }
    else
    {
        cell.detailTextLabel.text = [[episodes objectAtIndex:[indexPath row]] valueForProperty:MPMediaItemPropertyPodcastTitle];
    }


    
    [VSCArtworkCatcher fetchArtworkForPodcast:[episodes objectAtIndex:[indexPath row]] forImageView:cell.imageView withSize:CGSizeMake(88, 88)];
    
    // Configure the cell...
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {

    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) 
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPMusicPlayerController *ctrl = [MPMusicPlayerController iPodMusicPlayer];
    [ctrl setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:[NSArray arrayWithObject:[episodes objectAtIndex:[indexPath row]]]]];
    [ctrl play];
    
    VSCPlayView *play = [VSCPlayView new];
    [self presentModalViewController:play animated:YES];
    
    [tv deselectRowAtIndexPath:indexPath animated:YES];
}


@end
