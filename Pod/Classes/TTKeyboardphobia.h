@interface TTKeyboardphobia : NSObject

+ (BOOL)isKeyboardVisible;

@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, weak) UITapGestureRecognizer *hideKeyboardTap;
@property (nonatomic, assign, readonly) BOOL isKeyboardVisible;

- (void)registerView:(UIView *)view;
- (void)registerView:(UIView *)view inScrollView:(UIScrollView *)scrollView;
- (void)unregisterView:(UIView *)view;
- (void)unregisterViews;

@end
