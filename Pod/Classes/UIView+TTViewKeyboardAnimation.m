#import "UIView+TTViewKeyboardAnimation.h"

@implementation UIView (TTViewKeyboardAnimation)

+ (UIViewAnimationCurve)tt_keyboardAnimationCurve:(NSNotification *)notification {
    return (UIViewAnimationCurve) [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
}

+ (double)tt_keyboardAnimationDuration:(NSNotification *)notification {
    return [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}

+ (void)tt_animateWithKeyboardNotification:(NSNotification *)notification animations:(void (^)(void))animations {
    [CATransaction begin];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[UIView tt_keyboardAnimationDuration:notification]];
    [UIView setAnimationCurve:[UIView tt_keyboardAnimationCurve:notification]];
    [UIView setAnimationBeginsFromCurrentState:YES];

    animations();

    [UIView commitAnimations];
    [CATransaction commit];
}

@end