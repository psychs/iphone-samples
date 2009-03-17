// Created by Satoshi Nakagawa.
// You can redistribute it and/or modify it under the new BSD license.

#import <UIKit/UIKit.h>
#import "MapView.h"

@interface MapViewController : UIViewController <UIScrollViewDelegate>
{
	IBOutlet UIScrollView* scrollView;
	IBOutlet MapView* imageView;
	
	int imageSize;
}
@end
