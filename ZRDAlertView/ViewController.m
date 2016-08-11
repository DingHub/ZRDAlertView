//
//  ViewController.m
//  ZRDAlertView
//
//  Created by admin on 16/2/26.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import "ViewController.h"
#import "ZRDAlertView.h"
#import "InputView.h"

@interface ViewController ()

@property (nonatomic, strong) ZRDAlertView *alertView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self showAlertForRow:indexPath.row];
}

- (void)showAlertForRow:(NSInteger)row {
    switch (row) {
        case 0: {
            [self.view endEditing:YES];
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth*0.56, screenWidth*0.70)];
            view.backgroundColor = [UIColor greenColor];
            self.alertView.centerView = view;
            self.alertView.shouldDismissOnTapBlank = YES;
            self.alertView.backGroundAlph = 0.0f;
            [self.alertView show];
            break;
        }
        case 1: {
            InputView *view = [InputView view];
            [view.textfield becomeFirstResponder];
            [view.button addTarget:self action:@selector(inputViewButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            self.alertView.centerView = view;
            self.alertView.shouldDismissOnTapBlank = YES;
            [self.alertView show];
            break;
        }
        case 2: {
            [self.view endEditing:YES];
            self.alertView.centerView = [self creatViewWithCancelButton];
            self.alertView.shouldDismissOnTapBlank = NO;
            [self.alertView show];
            break;
        }
        default: {
            [self.alertView show];
            self.alertView.shouldDismissOnTapBlank = YES;
        }
    }
}

- (UIView *)creatViewWithCancelButton {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat screenWidth = screenSize.width < screenSize.height ? screenSize.width : screenSize.height;
    
    CGFloat width = screenWidth * 0.8, height = screenWidth * 0.9;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    
    UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width * 0.6, width * 0.9)];
    mainView.center = view.center;
    mainView.backgroundColor = [UIColor orangeColor];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cancelButton.frame = CGRectMake(mainView.frame.size.width + mainView.frame.origin.x - 15, mainView.frame.origin.y - 15, 30, 30);
    [cancelButton setImage:[UIImage imageNamed:@"errorCross"] forState:UIControlStateNormal];
    
    UILabel *hintLabel = [UILabel new];
    hintLabel.text = @"Hello!";
    [hintLabel sizeToFit];
    [mainView addSubview:hintLabel];
    hintLabel.center = CGPointMake(mainView.bounds.size.width/2, mainView.bounds.size.height/2);
    
    [view addSubview:mainView];
    [view addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

- (void)inputViewButtonTapped:(UIButton *)button {
    NSLog(@"OK button");
    InputView *view = (InputView *)button.superview;
    UITextField *textField = view.textfield;
    [textField resignFirstResponder];
}

- (void)cancelButtonTapped:(UIButton *)button {
    NSLog(@"Cancel button");
    ZRDAlertView *view = (ZRDAlertView *)button.superview.superview;
    [view dismiss];
}

- (ZRDAlertView *)alertView {
    if (_alertView == nil) {
        _alertView = [ZRDAlertView new];
    }
    return _alertView;
}

@end
