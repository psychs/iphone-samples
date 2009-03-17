// Created by Satoshi Nakagawa.
// You can redistribute it and/or modify it under the new BSD license.

#import "MapView.h"

@implementation MapView

@synthesize previousScale;

- (void)setUp
{
	if (initialized) return;
	
	initialized = YES;
	previousScale = 1;
}

- (id)initWithFrame:(CGRect)rect
{
	if (self = [super initWithFrame:rect]) {
		[self setUp];
	}
	return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
	if (self = [super initWithCoder:coder]) {
		[self setUp];
	}
	return self;
}

- (void)setTransformWithoutScaling:(CGAffineTransform)value;
{
	[super setTransform:value];
}

- (void)setTransform:(CGAffineTransform)value;
{
	[self setUp];
	[super setTransform:CGAffineTransformScale(value, 1.0f / previousScale, 1.0f / previousScale)];
}

@end
