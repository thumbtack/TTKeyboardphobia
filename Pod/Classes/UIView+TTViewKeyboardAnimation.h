#import <Foundation/Foundation.h>

@interface UIView (TTViewKeyboardAnimation)

+ (void)tt_animateWithKeyboardNotification:(NSNotification *)notification animations:(void (^)(void))animations;
+ (UIViewAnimationCurve)tt_keyboardAnimationCurve:(NSNotification *)notification;
+ (double)tt_keyboardAnimationDuration:(NSNotification *)notification;

@end