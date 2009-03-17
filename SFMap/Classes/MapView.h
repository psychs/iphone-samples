// Created by Satoshi Nakagawa.
// You can redistribute it and/or modify it under the new BSD license.

#import <UIKit/UIKit.h>

@interface MapView : UIImageView
{
	BOOL initialized;
	float previousScale;
}

@property (nonatomic, assign) float previousScale;

- (void)setTransformWithoutScaling:(CGAffineTransform)value;

@end
