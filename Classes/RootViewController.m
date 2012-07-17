//
//  RootViewController.m
//  oBoobs
//
//  Created by Alexander Bodnarashik on 17/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "FeedLoader.h"
#import "ImageLoader.h"
#import "Fullscreen.h"


@interface RootViewController()
-(void) image:(NSString*)url forCell:(UITableViewCell*)cell;
@end

@implementation RootViewController

@synthesize boobsItems;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.boobsItems = [NSMutableArray array];
	[[NSNotificationCenter defaultCenter] addObserver:self.tableView 
                                             selector:@selector(reloadData)
                                                 name:@"imageLoaded"
                                               object:nil];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURL *url = [NSURL URLWithString:@"http://api.oboobs.ru/boobs/0/100/-id"];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
	FeedLoader *feedLoader = [[FeedLoader alloc]initWithController:self];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:feedLoader];
	[feedLoader release];
    if (!theConnection) {
        NSLog(@"Connection failed");
    }    
    [theConnection release];  
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
}
-(void) feedParsed:(NSArray *)feed {
	self.boobsItems = [[NSMutableArray alloc]initWithCapacity:[feed count]];
	for (NSDictionary *item in feed) {
		[boobsItems addObject:item];
	}
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self.tableView reloadData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return YES;
}



#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [boobsItems count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	NSDictionary *feedItem = [boobsItems objectAtIndex:indexPath.row];
    cell.textLabel.text = [feedItem objectForKey:@"model"];
	NSString *url = [@"http://media.oboobs.ru/" stringByAppendingString:[feedItem objectForKey:@"preview"]];
	[self image:url forCell:cell];

    return cell;
}

-(void) image:(NSString*)url forCell:(UITableViewCell*)cell {
	[[ImageLoader getInstance] loadPath:url forImageView:cell.imageView];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Fullscreen *fs = [[Fullscreen alloc]initWithNibName:@"Fullscreen" bundle:nil];
	fs.navigationItem.title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
	fs.url = [@"http://media.oboobs.ru/" stringByAppendingString:[[[boobsItems objectAtIndex:indexPath.row]objectForKey:@"preview"] stringByReplacingOccurrencesOfString:@"boobs_preview" withString:@"boobs"]];
	[self.navigationController pushViewController:fs animated:YES];
	[fs release];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	self.boobsItems = nil;
    [super dealloc];
}


@end

