// Created by Satoshi Nakagawa.
// You can redistribute it and/or modify it under the new BSD license.

#import <objc/runtime.h>
#import "PSWebView.h"

@interface NSObject (UIWebViewTappingDelegate)
- (void)webView:(UIWebView*)sender zoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event;
- (void)webView:(UIWebView*)sender tappedWithTouch:(UITouch*)touch event:(UIEvent*)event;
@end

@interface PSWebView (Private)
- (void)fireZoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event;
- (void)fireTappedWithTouch:(UITouch*)touch event:(UIEvent*)event;
@end

@implementation UIView (__TapHook)

- (void)__touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self __touchesEnded:touches withEvent:event];
	
	id webView = [[self superview] superview];
	if (touches.count > 1) {
		if ([webView respondsToSelector:@selector(fireZoomingEndedWithTouches:event:)]) {
			[webView fireZoomingEndedWithTouches:touches event:event];
		}
	}
	else {
		if ([webView respondsToSelector:@selector(fireTappedWithTouch:event:)]) {
			[webView fireTappedWithTouch:[touches anyObject] event:event];
		}
	}
}

@end

static BOOL hookInstalled = NO;

static void installHook()
{
	if (hookInstalled) return;
	
	hookInstalled = YES;
	
	Class klass = objc_getClass("UIWebDocumentView");
	Method targetMethod = class_getInstanceMethod(klass, @selector(touchesEnded:withEvent:));
	Method newMethod = class_getInstanceMethod(klass, @selector(__touchesEnded:withEvent:));
	method_exchangeImplementations(targetMethod, newMethod);
}

@implementation PSWebView

- (id)initWithCoder:(NSCoder*)coder
{
    if (self = [super initWithCoder:coder]) {
		installHook();
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
		installHook();
    }
    return self;
}

- (void)fireZoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event
{
	if ([self.delegate respondsToSelector:@selector(webView:zoomingEndedWithTouches:event:)]) {
		[(NSObject*)self.delegate webView:self zoomingEndedWithTouches:touches event:event];
	}
}

- (void)fireTappedWithTouch:(UITouch*)touch event:(UIEvent*)event
{
	if ([self.delegate respondsToSelector:@selector(webView:tappedWithTouch:event:)]) {
		[(NSObject*)self.delegate webView:self tappedWithTouch:touch event:event];
	}
}

@end
