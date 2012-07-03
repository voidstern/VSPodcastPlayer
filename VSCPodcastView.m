//
//  VSCPodcastView.m
//  PodcastPlayer
//
//  Created by Lukas Burgstaller on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VSCPodcastView.h"
#import "VSCPodcastLibary.h"
#import "MPMediaItemProperties.h"
#import "VSCArtworkCatcher.h"
#import "VSCEpisodesView.h"
#import "VSCPlayView.h"

@implementation VSCPodcastView

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
    self = [super init];
    if (self) 
    {
        podcasts = [[VSCPodcastLibary sharedInstance] podcastsForTitles:titles];
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
            NSString *a = [[obj1 representativeItem] valueForProperty:MPMediaItemPropertyPodcastTitle];
            NSString *b = [[obj2 representativeItem] valueForProperty:MPMediaItemPropertyPodcastTitle];
            
            return [a compare:b];
        };
        
        podcasts = [[podcasts sortedArrayUsingComparator:sortBlock] mutableCopy];
    }
    else if (segmentCtrl.selectedSegmentIndex == 1) // Sort Episodes
    {
        NSComparisonResult (^sortBlock)(id, id) = ^(id obj1, id obj2) 
        {
            NSDate *a = [NSDate date];
            NSDate *b = [NSDate date];
            
            for (MPMediaItem *item in [obj1 items]) 
            {
                if ([a compare:[item valueForProperty:MPMediaItemPropertyReleaseDate]] != NSOrderedAscending)
                {
                    a = [item valueForProperty:MPMediaItemPropertyReleaseDate];
                }
            }
            
            for (MPMediaItem *item in [obj2 items]) 
            {
                if ([b compare:[item valueForProperty:MPMediaItemPropertyReleaseDate]] != NSOrderedAscending)
                {
                    b = [item valueForProperty:MPMediaItemPropertyReleaseDate];
                }
            }
            
            return [b compare:a];
        };
        
        podcasts = [[podcasts sortedArrayUsingComparator:sortBlock] mutableCopy];
    }
    else // Sort Date
    {
        NSComparisonResult (^sortBlock)(id, id) = ^(id obj1, id obj2) 
        {
            NSInteger a = [[VSCPodcastLibary sharedInstance] unplayedEpisodesForTitles:[NSArray arrayWithObject:[[obj1 representativeItem] valueForProperty:MPMediaItemPropertyPodcastTitle]]];
            NSInteger b = [[VSCPodcastLibary sharedInstance] unplayedEpisodesForTitles:[NSArray arrayWithObject:[[obj2 representativeItem] valueForProperty:MPMediaItemPropertyPodcastTitle]]];
            
            if (a > b) 
            {
                return (NSComparisonResult)NSOrderedAscending;
            }
            else if (b > a)
            {
                return (NSComparisonResult)NSOrderedDescending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        
        podcasts = [[podcasts sortedArrayUsingComparator:sortBlock] mutableCopy];
    }
    
    [tableView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)showPlayView:(id)sender 
{
    VSCPlayView *play = [VSCPlayView new];
    [self presentModalViewController:play animated:YES];
}

#pragma mark - View lifecycle

- (void) viewDidAppear:(BOOL)animated
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    l.textAlignment = UITextAlignmentCenter;
    l.text = [NSString stringWithFormat:NSLocalizedString(@"%d Podcasts", nil), [podcasts count]];
    l.textColor = [UIColor lightGrayColor];
    
    tableView.tableFooterView = l;
    self.navigationItem.rightBarButtonItem = playing;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    segmentCtrl = nil;
    tableView = nil;
    playing = nil;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else
    {
        return [podcasts count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    
    if ([indexPath section] == 0)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        if ([indexPath row] == 0) 
        {
            cell.textLabel.text = @"All Episodes";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else 
        {
            cell.textLabel.text = @"Unfinished";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = [[[podcasts objectAtIndex:[indexPath row]] representativeItem] podcastTitle];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Episodes", [[podcasts objectAtIndex:[indexPath row]] count]];
        [VSCArtworkCatcher fetchArtworkForPodcast:[[podcasts objectAtIndex:[indexPath row]] representativeItem] forImageView:cell.imageView withSize:CGSizeMake(88, 88)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSInteger unplayed = [[VSCPodcastLibary sharedInstance] unplayedEpisodesForTitles:[NSArray arrayWithObject:cell.textLabel.text]];
        NSInteger episodes = [[VSCPodcastLibary sharedInstance] episodesForTitles:[NSArray arrayWithObject:cell.textLabel.text]];
        
        if (unplayed != 0) 
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
        
        NSString *detail = [NSString stringWithFormat:@"%d of %d unplayed", unplayed, episodes];
        
        cell.detailTextLabel.text = detail;
    }
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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
    if ([indexPath section] == 0)
    {
        if ([indexPath row] == 0) 
        {
            VSCEpisodesView *view = [[VSCEpisodesView alloc] initWithPodcastTitles:podcastTitles];
            view.title = NSLocalizedString(@"All Episodes", nil);
            [self.navigationController pushViewController:view animated:YES];
        }
        else 
        {
            VSCEpisodesView *view = [[VSCEpisodesView alloc] initWithPodcastTitles:podcastTitles unfinished:YES];
            view.title = NSLocalizedString(@"Unfinished", nil);
            [self.navigationController pushViewController:view animated:YES];
        }
    }
    else
    {
        NSString *title = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
        NSArray *titles = [NSArray arrayWithObject:title];
        VSCEpisodesView *view = [[VSCEpisodesView alloc] initWithPodcastTitles:titles];
        view.title = title;
        [self.navigationController pushViewController:view animated:YES];
    }
}

@end
