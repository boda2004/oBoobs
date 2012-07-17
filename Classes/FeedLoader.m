//
//  FeedLoader.m
//  oBoobs
//
//  Created by Alexander Bodnarashik on 17/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FeedLoader.h"
#import "JSONKit.h"
#import "RootViewController.h"

@implementation FeedLoader

@synthesize data;
@synthesize delegate;

-(id) initWithController:(RootViewController*)controller {
	self = [super init];
	if (self) {
		data = [[NSMutableData alloc] init];
		self.delegate = controller;
	}
	return self;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [data appendData:d];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"loaded");
	JSONDecoder *decoder = [JSONDecoder new];
	NSError *err = nil;
	NSArray *feed = [decoder objectWithData:self.data error:&err];
	[decoder release];
	if (err) {
		NSLog(@"error: %s",[err localizedDescription]);
		[delegate performSelectorOnMainThread:@selector(feedParsed:) withObject:[NSArray array] waitUntilDone:YES];
	} else {
		[delegate performSelectorOnMainThread:@selector(feedParsed:) withObject:feed waitUntilDone:YES];
	}
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
	[delegate performSelectorOnMainThread:@selector(feedParsed:) withObject:[NSArray array] waitUntilDone:YES];
}

-(void) dealloc {
	data = nil;
	delegate = nil;
	[super dealloc];
}
@end
