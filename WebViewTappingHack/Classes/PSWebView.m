#import <objc/objc-runtime.h>
#import "PSWebView.h"

const char* kUIWebDocumentView = "UIWebDocumentView";

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
	// dummy implementation
}

- (void)__myTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self __touchesEnded:touches withEvent:event];
	
	PSWebView* webView = (PSWebView*)[[self superview] superview];
	if (touches.count > 1) {
		[webView fireZoomingEndedWithTouches:touches event:event];
	}
	else {
		[webView fireTappedWithTouch:[touches anyObject] event:event];
	}
}

@end

static void installHook(UIView* view)
{
	Class klass = [view class];
	
	Method target_method = class_getInstanceMethod(klass, @selector(touchesEnded:withEvent:));
	Method alias_method = class_getInstanceMethod(klass, @selector(__touchesEnded:withEvent:));
	Method new_method = class_getInstanceMethod(klass, @selector(__myTouchesEnded:withEvent:));
	
	method_setImplementation(alias_method, method_getImplementation(target_method));
	method_setImplementation(target_method, method_getImplementation(new_method));
}

@implementation PSWebView

- (void)setUp
{
	NSArray* views = [[[self subviews] objectAtIndex:0] subviews];
	for (id view in views) {
		const char* name = object_getClassName(view);
		if (!strncmp(name, kUIWebDocumentView, strlen(name))) {
			installHook(view);
			break;
		}
	}
}

- (id)initWithCoder:(NSCoder*)coder
{
    if (self = [super initWithCoder:coder]) {
		[self setUp];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
		[self setUp];
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
