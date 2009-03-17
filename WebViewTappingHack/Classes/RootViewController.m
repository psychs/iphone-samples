// Created by Satoshi Nakagawa.
// You can redistribute it and/or modify it under the new BSD license.

#import "RootViewController.h"

@implementation RootViewController

- (void)dealloc
{
	[super dealloc];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.yahoo.co.jp/"]]];
}

- (void)webView:(UIWebView*)sender zoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event
{
	NSLog(@"finished zooming");
}

- (void)webView:(UIWebView*)sender tappedWithTouch:(UITouch*)touch event:(UIEvent*)event
{
	NSLog(@"tapped");
}

@end
