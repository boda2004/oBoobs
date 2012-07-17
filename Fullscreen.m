//
//  Fullscreen.m
//  oBoobs
//
//  Created by Alexander Bodnarashik on 17/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Fullscreen.h"
#import "ImageLoader.h"

@interface Fullscreen()
-(void) refreshImage;

@end


@implementation Fullscreen
@synthesize iv;
@synthesize url;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(refreshImage)
                                                 name:@"imageLoaded"
                                               object:nil];
	[self refreshImage];
	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
}

-(void) refreshImage {
	[[ImageLoader getInstance] loadPath:self.url forImageView:self.iv];
}

- (void)dealloc {
    [super dealloc];
}


@end
