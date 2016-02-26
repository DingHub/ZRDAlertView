//
//  ZRDAlertView.m
//  ZRDAlertView
//
//  Created by admin on 16/2/26.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import "ZRDAlertView.h"

@interface ZRDAlertView () {
    UITapGestureRecognizer *_recognizer;
}

@end


@implementation ZRDAlertView


- (id)init {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}


// show alert view on the window
- (void)show {
    
    _centerView.layer.shouldRasterize = YES;
    _centerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    // On iOS7, calculate with orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                break;
            case UIInterfaceOrientationLandscapeRight:
                self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                break;
            default:
                break;
        }
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        // On iOS7 and later, just place the centerView in the middle
    } else {
        CGSize viewSize = _centerView.frame.size;
        CGSize screenSize = [self actualScreeSize];
        CGFloat x = (screenSize.width - viewSize.width)/2;
        CGFloat y = (screenSize.height - viewSize.height)/2;
        _centerView.frame = CGRectMake(x, y, viewSize.width, viewSize.height);
    }
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    
    _centerView.layer.opacity = 0.5f;
    _centerView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         _centerView.layer.opacity = 1.0f;
                         _centerView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL
     ];
}

// alert view remove from the window
- (void)dismiss {
    CATransform3D currentTransform = _centerView.layer.transform;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat startRotation = [[_centerView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
        CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
        _centerView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    }
    
    _centerView.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         _centerView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         _centerView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [_centerView removeFromSuperview];
                         [self removeGestureRecognizer:_recognizer];
                         [self removeFromSuperview];
                     }
     ];
}

//setters

- (void)setCenterView:(UIView *)centerView {
    _centerView = centerView;
    [self addSubview:centerView];
}

- (void)setShouldDismissOnTapBlank:(BOOL)shouldDismissOnTapBlank {
    _shouldDismissOnTapBlank = shouldDismissOnTapBlank;
    if (shouldDismissOnTapBlank) {
        if (_shouldDismissOnTapBlank) {
            _recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector((dismiss))];
            [self addGestureRecognizer:_recognizer];
        } else {
            [self removeGestureRecognizer:_recognizer];
        }
    }
}

// helper functions

- (CGSize)actualScreeSize {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // Below iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGSizeMake(screenWidth, screenHeight);
}

- (void)keyboardWillShow: (NSNotification *)notification {
    CGSize screenSize = [self actualScreeSize];
    CGSize centerSize = _centerView.bounds.size;
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation) && NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         _centerView.frame = CGRectMake((screenSize.width - centerSize.width) / 2, (screenSize.height - keyboardSize.height - centerSize.height) / 2, centerSize.width, centerSize.height);
                     }
                     completion:nil
     ];
}

- (void)keyboardWillHide: (NSNotification *)notification {
    CGSize screenSize = [self actualScreeSize];
    CGSize centerSize = _centerView ? _centerView.bounds.size : CGSizeZero;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         _centerView.frame = CGRectMake((screenSize.width - centerSize.width) / 2, (screenSize.height - centerSize.height) / 2, centerSize.width, centerSize.height);
                     }
                     completion:nil
     ];
}

- (void)deviceOrientationDidChange: (NSNotification *)notification {
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [self changeOrientationBelowIOS7];
    } else {
        [self changeOrientationAboveIOS7:notification];
    }
}

- (void)changeOrientationBelowIOS7 {
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CGAffineTransform rotation;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 270.0 / 180.0);
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 90.0 / 180.0);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 180.0 / 180.0);
            break;
            
        default:
            rotation = CGAffineTransformMakeRotation(-startRotation + 0.0);
            break;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         _centerView.transform = rotation;
                     }
                     completion:nil
     ];
    
}

- (void)changeOrientationAboveIOS7: (NSNotification *)notification {
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGSize centerSize = _centerView.frame.size;
                         CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
                         self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
                         _centerView.frame = CGRectMake((screenWidth - centerSize.width) / 2, (screenHeight - keyboardSize.height - centerSize.height) / 2, centerSize.width, centerSize.height);
                     }
                     completion:nil
     ];
    
}

- (void)dealloc {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


@end
