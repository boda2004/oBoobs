//
//  FeedLoader.h
//  oBoobs
//
//  Created by Alexander Bodnarashik on 17/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RootViewController;

@interface FeedLoader : NSObject {
	NSMutableData *data;
	RootViewController *delegate;
}

@property(nonatomic, retain) NSMutableData *data;
@property(nonatomic, retain) RootViewController *delegate;

-(id) initWithController:(RootViewController*)controller;

@end
