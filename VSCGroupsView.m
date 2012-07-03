//
//  VSCGroupsView.m
//  PodcastPlayer
//
//  Created by Lukas Burgstaller on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VSCGroupsView.h"
#import "VSCAppDelegate.h"
#import "VSCPodcastView.h"
#import "VSCPodcastLibary.h"
#import "VSCPlayView.h"

@implementation VSCGroupsView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = playingButton;
    self.navigationItem.title = @"Playlists";
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self loadCollection];
}

- (void)viewDidUnload
{
    playingButton = nil;
    tableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)showPlayView:(id)sender 
{
    VSCPlayView *play = [VSCPlayView new];
    [self presentModalViewController:play animated:YES];
}

- (void) loadCollection
{
    groups = [[VSCPodcastLibary sharedInstance] lists];
    [tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return [groups count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if ([indexPath section] == 0)
    {
        cell.textLabel.text = @"All Podcasts";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSArray *titles = [[VSCPodcastLibary sharedInstance] allPodcastTitles];
        
        NSInteger unplayed = [[VSCPodcastLibary sharedInstance] unplayedEpisodesForTitles:titles];
        NSInteger episodes = [[VSCPodcastLibary sharedInstance] episodesForTitles:titles];
        
        NSString *detail = [NSString stringWithFormat:@"%d of %d unplayed", unplayed, episodes];
        
        cell.detailTextLabel.text = detail;
        
    }
    else
    {
        cell.textLabel.text = [[groups objectAtIndex:[indexPath row]] title];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSArray *titles = [[[groups objectAtIndex:[indexPath row]] podcasts] allObjects];
        
        NSInteger unplayed = [[VSCPodcastLibary sharedInstance] unplayedEpisodesForTitles:titles];
        NSInteger episodes = [[VSCPodcastLibary sharedInstance] episodesForTitles:titles];
        
        NSString *detail = [NSString stringWithFormat:@"%d of %d unplayed", unplayed, episodes];
        
        cell.detailTextLabel.text = detail;
    }
    
    // Configure the cell...
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

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
        NSArray *titles = [[VSCPodcastLibary sharedInstance] allPodcastTitles];
        VSCPodcastView *view = [[VSCPodcastView alloc] initWithPodcastTitles:titles];
        view.title = NSLocalizedString(@"All Podcasts", nil);
        [self.navigationController pushViewController:view animated:YES];
    }
    else
    {
        NSArray *titles = [[[groups objectAtIndex:[indexPath row]] podcasts] allObjects];
        VSCPodcastView *view = [[VSCPodcastView alloc] initWithPodcastTitles:titles];
        view.title = [[groups objectAtIndex:[indexPath row]] title];
        [self.navigationController pushViewController:view animated:YES];
    }
}


@end
