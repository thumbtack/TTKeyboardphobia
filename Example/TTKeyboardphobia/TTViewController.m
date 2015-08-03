#import "TTViewController.h"
#import "TTKeyboardphobiaPlaygroundController.h"

@implementation TTViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    TTKeyboardphobiaPlaygroundController *playground = [[TTKeyboardphobiaPlaygroundController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController presentViewController:playground animated:YES completion:nil];
}

@end
