//
//  RootViewController.h
//  oBoobs
//
//  Created by Alexander Bodnarashik on 17/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
	NSMutableArray *boobsItems;
}
@property(nonatomic, retain) NSMutableArray *boobsItems;

-(void) feedParsed:(NSArray *)feed;
@end
