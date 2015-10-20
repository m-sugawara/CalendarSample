//
//  CATScheduleDetailViewController.m
//  CalendarTest
//
//  Created by m_sugawara on 2015/08/28.
//  Copyright (c) 2015年 Zappallas. All rights reserved.
//

#import "CATScheduleDetailViewController.h"

// Pods
#import <RMPZoomTransitionAnimator/RMPZoomTransitionAnimator.h>

@interface CATScheduleDetailViewController () <RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>

@end

@implementation CATScheduleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RMPZoomTransitioningAnimating
- (UIImageView *)transitionSourceImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.selectedImageView.image];
    imageView.contentMode = self.selectedImageView.contentMode;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = NO;
    imageView.frame = self.selectedImageView.frame;
    return imageView;
}

- (UIColor *)transitionSourceBackgroundColor {
    return self.view.backgroundColor;
}

- (CGRect)transitionDestinationImageViewFrame {
    [self.view layoutIfNeeded];
    return self.selectedImageView.frame;
}

#pragma mark - RMPZoomTransitionDelegate
- (void)zoomTransitionAnimator:(RMPZoomTransitionAnimator *)animator didCompleteTransition:(BOOL)didComplete animatingSourceImageView:(UIImageView *)imageView {
    
    self.selectedImageView.image = imageView.image;
}

@end
