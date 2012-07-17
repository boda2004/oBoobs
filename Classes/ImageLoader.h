//
//  ImageLoader.h
//  oBoobs
//
//  Created by Alexander Bodnarashik on 17/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageLoader : NSObject {
	NSMutableArray *queue;
	NSMutableDictionary *loaded;
	BOOL running;
}
@property(nonatomic, retain) NSMutableArray *queue;
@property(nonatomic, retain) NSMutableDictionary *loaded;
@property(nonatomic, assign) BOOL running;

-(void) loadPath:(NSString *)path forImageView:(UIImageView*)image;
+(id) getInstance;
@end
