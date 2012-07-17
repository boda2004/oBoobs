//
//  ImageLoader.m
//  oBoobs
//
//  Created by Alexander Bodnarashik on 17/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageLoader.h"

static ImageLoader *instance = nil;

@interface ImageLoader()
-(void) run;
@end

@implementation ImageLoader
@synthesize queue;
@synthesize loaded;
@synthesize running;

NSMutableData *data = nil;
NSString *currentUrl = nil;

+(id) getInstance {
	if (instance == nil) {
		instance = [[ImageLoader alloc]init];
	}
	return instance;
}

-(id) init {
	self = [super init];
	if (self) {
		self.queue = [[NSMutableArray alloc]init];
		self.loaded = [[NSMutableDictionary alloc]init];
	}
	return self;
}

-(void) loadPath:(NSString *)path forImageView:(UIImageView*)imageView {
	@synchronized(self) {
		UIImage *image = [self.loaded objectForKey:path];
		[imageView setImage:image];
		if (!image && ![self.queue containsObject:path]){
			[self.queue addObject:path];
			if (!running) {
				[self run];
			}
		}
	}
}

-(void) run {
	@synchronized(self) {
		while(true) {
			if ([self.queue count] == 0) return;
			if (self.running) return;
			currentUrl = [[self.queue lastObject] retain];
			[self.queue removeLastObject];
			
			data =[[NSMutableData alloc]init];
			
			NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:currentUrl]
													  cachePolicy:NSURLRequestUseProtocolCachePolicy
												  timeoutInterval:60.0];
			NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
			if (!theConnection) {
				NSLog(@"Connection failed");
				continue;
			}    
			self.running = YES;
			[theConnection release];  
		}
	}
	
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [data appendData:d];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	@synchronized(self) {
		NSLog(@"Loaded: %@",currentUrl);
		self.running = NO;
		[self.loaded setObject:[UIImage imageWithData:data] forKey:currentUrl];
		[currentUrl release];
		currentUrl = nil;
		[data release];
		data = nil;
		[self run];
		[[NSNotificationCenter defaultCenter]postNotificationName:@"imageLoaded" object: nil];
	}
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
	@synchronized(self) {
		self.running = NO;
		[currentUrl release];
		currentUrl = nil;
		[data release];
		data = nil;
		[self run];
	}
}


-(void) dealloc {
	self.queue = nil;
	self.loaded = nil;
	[super dealloc];
}
@end
