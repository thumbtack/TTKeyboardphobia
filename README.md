# TTKeyboardphobia

[![Version](https://img.shields.io/cocoapods/v/TTKeyboardphobia.svg?style=flat)](http://cocoapods.org/pods/TTKeyboardphobia)
[![License](https://img.shields.io/cocoapods/l/TTKeyboardphobia.svg?style=flat)](http://cocoapods.org/pods/TTKeyboardphobia)
[![Platform](https://img.shields.io/cocoapods/p/TTKeyboardphobia.svg?style=flat)](http://cocoapods.org/pods/TTKeyboardphobia)

## Usage

```
#import "TTKeyboardphobia.h"

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keyboardphobia = [[TTKeyboardphobia alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.keyboardphobia registerView:self.textView inScrollView:self.scrollView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.keyboardphobia unregisterViews];
    # Or, to unregister just a single view:
    # [self.keyboardphobia unregisterView:self.textView];
}
```

You can also nest your input views inside a container view, TTKeyboardphobia will then align the frame of the container view with the top edge of the keyboard. Simply register your container instead of the input view directly:

```
[self.keyboardphobia registerView:self.textViewContainer inScrollView:self.scrollView];
```

TTKeyboardphobia will search the view hierarchy for the first responder, so you can nest your input in multiple container views if you wish.

## Installation

TTKeyboardphobia is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TTKeyboardphobia"
```

## Author

Ian Leitch, ileitch@thumbtack.com

## License

TTKeyboardphobia is available under the BSD license. See the LICENSE file for more info.
