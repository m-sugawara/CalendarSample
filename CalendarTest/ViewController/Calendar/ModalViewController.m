//
//  ModalViewController.m
//  CalendarTest
//
//  Created by m_sugawara on 2015/06/12.
//  Copyright (c) 2015年 Zappallas. All rights reserved.
//

#import "ModalViewController.h"

@interface ModalViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *redView = [UIView new];
    redView.backgroundColor = [UIColor brownColor];
    redView.frame = CGRectMake(0, 0,
                           self.view.bounds.size.width * 2,
                           self.view.bounds.size.height * 2);
    
    self.scrollView.contentSize = redView.bounds.size;
    [self.scrollView addSubview:redView];
    
    UIButton *closeButton = [UIButton new];
    closeButton.frame = CGRectMake(0, 0, 100, 100);
    [closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitle:@"close" forState:UIControlStateNormal];
    [self.scrollView addSubview:closeButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

@end
