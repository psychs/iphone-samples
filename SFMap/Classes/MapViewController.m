// Created by Satoshi Nakagawa.
// You can redistribute it and/or modify it under the new BSD license.

#import "MapViewController.h"
#import "MapView.h"

#define MIN_SIZE 320
#define MAX_SIZE 1600
#define RATIO 0.75

@implementation MapViewController

- (void)dealloc
{
	[scrollView release];
	[imageView release];
	[super dealloc];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	imageSize = MIN_SIZE;
	
	imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"map_%d.png", imageSize]];
	imageView.frame = CGRectMake(0, 0, imageSize * RATIO, imageSize);
	scrollView.contentSize = CGSizeMake(imageSize * RATIO, imageSize);
	scrollView.maximumZoomScale = MAX_SIZE / (float)imageSize;
	scrollView.minimumZoomScale = MIN_SIZE / (float)imageSize;
	scrollView.alwaysBounceVertical = YES;
	scrollView.alwaysBounceHorizontal = YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)sender
{
	return imageView;
}

- (void)update:(NSNumber*)scaleNum
{
	float scale = [scaleNum floatValue];
	int width = MIN_SIZE * scale;

	int newWidth;
	if (width <= 360) {
		newWidth = 320;
	}
	else if (width <= 480) {
		newWidth = 480;
	}
	else if (width <= 640) {
		newWidth = 640;
	}
	else if (width <= 960) {
		newWidth = 960;
	}
	else if (width <= 1280) {
		newWidth = 1280;
	}
	else {
		newWidth = 1600;
	}

	if (newWidth != imageSize) {
		imageSize = newWidth;
		imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"map_%d.png", imageSize]];
		imageView.previousScale = (float)imageSize / MIN_SIZE;
		imageView.transform = CGAffineTransformMakeScale(scale, scale);
		imageView.frame = CGRectMake(0, 0, width * RATIO, width);
	}
	
	scrollView.contentSize = CGSizeMake(width * RATIO, width);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)sender withView:(UIView *)view atScale:(float)scale
{
	[self performSelector:@selector(update:) withObject:[NSNumber numberWithFloat:scale] afterDelay:0];
}

@end
