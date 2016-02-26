

#import "InputView.h"

@implementation InputView


+ (instancetype)view {
    InputView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    return view;
}

@end
