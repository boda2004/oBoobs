//
//  Fullscreen.h
//  oBoobs
//
//  Created by Alexander Bodnarashik on 17/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Fullscreen : UIViewController {
	IBOutlet UIImageView *iv;
	NSString *url;

}
@property(nonatomic,retain) UIImageView *iv;
@property(nonatomic,retain) NSString *url;

@end
