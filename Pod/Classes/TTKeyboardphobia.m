#import "UIView+TTViewKeyboardAnimation.h"
#import "TTKeyboardphobia.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface TTKeyboardphobia ()
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, assign) UIEdgeInsets scrollIndicatorInsets;
@property (nonatomic, assign, readwrite) BOOL isKeyboardVisible;

@end

@implementation TTKeyboardphobia

+ (BOOL)isKeyboardVisible {
    return [[self sharedInstance] isKeyboardVisible];
}

+ (void)load {
    [self sharedInstance];
}

- (id)init {
    self = [super init];
    if (self) {
        _isKeyboardVisible = NO;
        _views = [@[] mutableCopy];
        _contentOffset = CGPointZero;
        _contentInset = UIEdgeInsetsZero;
        _scrollIndicatorInsets = UIEdgeInsetsZero;
        [self addObservers];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self unregisterViews];
}

- (void)registerView:(UIView *)view {
    [self registerView:view inScrollView:nil];
}

- (void)registerView:(UIView *)view inScrollView:(UIScrollView *)scrollView {
    if (scrollView) {
        [self.views addObject:NSDictionaryOfVariableBindings(view, scrollView)];
    } else {
        [self.views addObject:NSDictionaryOfVariableBindings(view)];
    }
}

- (void)unregisterView:(UIView *)view {
    NSDictionary *doomedPair = nil;

    for (NSDictionary *pair in self.views) {
        UIView *pairView = pair[@"view"];
        if (pairView == view) {
            doomedPair = pair;
            break;
        }
    }

    if (doomedPair) {
        [self.views removeObject:doomedPair];
    }

    if ([self.views count] == 0) {
        [self unregisterViews];
    }
}

- (void)unregisterViews {
    self.views = [@[] mutableCopy];
}


#pragma mark - Private

+ (TTKeyboardphobia *)sharedInstance {
    static TTKeyboardphobia *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)keyboardDidShowNotification:(NSNotification *)notification {
    self.hideKeyboardTap.enabled = YES;
}

- (void)keyboardDidHideNotification:(NSNotification *)notification {
    self.isKeyboardVisible = NO;
    self.hideKeyboardTap.enabled = NO;
}

- (void)keyboardWillShowNotification:(NSNotification *)notification {
    BOOL keyboardAlreadyVisible = self.isKeyboardVisible;
    self.isKeyboardVisible = YES;
    NSDictionary *pair = [self viewContainingFirstResponder];

    if (pair) {
        UIView *view = pair[@"view"];
        UIScrollView *scrollView = pair[@"scrollView"];

        if (scrollView) {
            CGSize kbSize = [self keyboardSizeForNotification:notification];

            if (keyboardAlreadyVisible) {
                CGPoint contentOffsetMinusKeyboard = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y - kbSize.height);
                self.contentOffset = contentOffsetMinusKeyboard;
            } else {
                self.contentInset = scrollView.contentInset;
                self.scrollIndicatorInsets = scrollView.scrollIndicatorInsets;
                self.contentOffset = scrollView.contentOffset;
            }

            UIResponder *responder = [self firstResponderInView:view];

            [self scrollToView:view inScrollView:scrollView forNotification:notification withResponder:responder keyboardAlreadyVisible:keyboardAlreadyVisible];
        }
    }
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    NSDictionary *pair = [self viewContainingFirstResponder];

    if (pair) {
        UIScrollView *scrollView = pair[@"scrollView"];

        if (scrollView) {
            [self resetScrollView:scrollView forNotification:notification];
        }
    }
}

- (NSDictionary *)viewContainingFirstResponder {
    for (NSDictionary *pair in self.views) {
        if ([self viewContainsFirstResponder:pair[@"view"]]) {
            return pair;
        }
    }

    return nil;
}

- (BOOL)viewContainsFirstResponder:(UIView *)view {
    return [self firstResponderInView:view] != nil;
}

- (UIResponder *)firstResponderInView:(UIView *)view {
    if ([view isFirstResponder]) {
        return view;
    }

    for (UIView *subview in [view subviews]) {
        UIResponder *responder = [self firstResponderInView:subview];

        if (responder) {
            return responder;
        }
    }

    return nil;
}

- (NSString *)keyForView:(UIView *)view {
    return [NSString stringWithFormat:@"%p", view];
}

- (void)scrollToView:(UIView *)view inScrollView:(UIScrollView *)scrollView forNotification:(NSNotification *)notification withResponder:(UIResponder *)responder keyboardAlreadyVisible:(BOOL)keyboardAlreadyVisible {
    CGSize kbSize = [self keyboardSizeForNotification:notification];
    [self setInsetsOnScrollView:scrollView forKeyboardSize:kbSize];

    UIView *accessoryView = responder.inputAccessoryView;
    CGRect visibleRect = scrollView.superview.frame;
    visibleRect.size.height -= kbSize.height;

    if (accessoryView) {
        visibleRect.size.height -= accessoryView.frame.size.height;
    }

    CGPoint origin = [view.superview convertPoint:view.frame.origin toView:scrollView.superview];

    if (visibleRect.origin.y > 0) {
        // In a view that contains a navigation bar, the scrollView's superview
        // Y coordiante will reflect this. However the editable view's superview
        // (which is likely a inside a content view) will have a Y coordinate of 0.
        // We need to act as if the both superviews are at the same coordinate.
        origin.y += visibleRect.origin.y;
    }

    CGPoint bottom = origin;
    bottom.y += view.frame.size.height;

    if (!CGRectContainsPoint(visibleRect, origin) || !CGRectContainsPoint(visibleRect, bottom)) {
        CGRect frame = view.frame;
        BOOL isOversized = frame.size.height > visibleRect.size.height;
        BOOL hasAccessoryView = accessoryView != nil;

        if (isOversized) {
            frame.size.height = visibleRect.size.height;

            if (hasAccessoryView) {
                // Oversized views with an inputAccessoryView need their Y origin
                // pushed down to ensure the to edge pins to the top of the superview.
                frame.origin.y += accessoryView.frame.size.height;
            }

            [self scrollRectToVisible:frame inScrollView:scrollView forNotification:notification keyboardAlreadyVisible:keyboardAlreadyVisible];
            return;
        }

        if (hasAccessoryView && keyboardAlreadyVisible && SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"8.0")) {
            // When an input becomes first responder and the keyboard is already
            // visible, the inputAccessoryView is not yet visible and scrollRectToVisible
            // is not able to correctly calculate the contentOffset.
            frame.origin.y += accessoryView.frame.size.height;
        }

        [self scrollRectToVisible:frame inScrollView:scrollView forNotification:notification keyboardAlreadyVisible:keyboardAlreadyVisible];
    }
}

- (void)scrollRectToVisible:(CGRect)frame inScrollView:(UIScrollView *)scrollView forNotification:(NSNotification *)notification keyboardAlreadyVisible:(BOOL)keyboardAlreadyVisible {
    if (keyboardAlreadyVisible) {
        [scrollView scrollRectToVisible:frame animated:YES];
    } else {
        [UIView tt_animateWithKeyboardNotification:notification animations:^{
            [scrollView scrollRectToVisible:frame animated:NO];
        }];
    }
}

- (void)resetScrollView:(UIScrollView *)scrollView forNotification:(NSNotification *)notification {
    [UIView tt_animateWithKeyboardNotification:notification animations:^{
        scrollView.contentOffset = self.contentOffset;
        scrollView.contentInset = self.contentInset;
        scrollView.scrollIndicatorInsets = self.scrollIndicatorInsets;
    }];
}

- (void)setInsetsOnScrollView:(UIScrollView *)scrollView forKeyboardSize:(CGSize)kbSize {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (CGSize)keyboardSizeForNotification:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    return [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShowNotification:)
                                                 name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHideNotification:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}

@end
