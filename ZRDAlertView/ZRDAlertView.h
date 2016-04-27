//
//  ZRDAlertView.h
//  ZRDAlertView
//
//  Created by admin on 16/2/26.
//  Copyright © 2016年 Ding. All rights reserved.
//

/**
 *  A very simple alertView, the view for show can be completely customed;
 *  Adjusted frame for device rotating and keyboard appearing/disappearing
 *
 *  Thanks for https://github.com/wimagguc/ios-custom-alertview 
 *  in fact, this alert view is a lite of  the linked one.
 */

#import <UIKit/UIKit.h>

@interface ZRDAlertView : UIView

// your costom view for show
@property (nonatomic, strong) UIView *centerView;

// when you tap on the blank , the alert view should dismiss, default is NO
@property (nonatomic, assign) BOOL shouldDismissOnTapBlank;

// the background color is black with alph (default is 0.4)
@property (nonatomic, assign) CGFloat backGroundAlph;

- (void)show;

- (void)dismiss;

@end
