//
//  CATScheduleViewController.m
//  CalendarTest
//
//  Created by m_sugawara on 2015/06/12.
//  Copyright (c) 2015年 Zappallas. All rights reserved.
//

#import "CATScheduleViewController.h"

#import "CATScheduleDetailViewController.h"

// Pods
#import <RMPZoomTransitionAnimator/RMPZoomTransitionAnimator.h>

const NSInteger kNumberOfYear = 12;

@implementation CATScheduleViewControllerTableViewCell

@end

@interface CATScheduleViewController () <UITableViewDelegate, UITableViewDataSource, UIBarPositioningDelegate, RMPZoomTransitionAnimating, RMPZoomTransitionDelegate, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) UIImageView *selectingImageView;

@end

@implementation CATScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private Methods


#pragma mark - LifeCycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    CATScheduleDetailViewController *vc = (CATScheduleDetailViewController *)segue.destinationViewController;
    
    vc.transitioningDelegate = self;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CATScheduleViewControllerTableViewCell *selectingCell = (CATScheduleViewControllerTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.selectingImageView = selectingCell.cellImageView;
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-  (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfYear;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:now];
    nowComponents.month += section;
    
    NSString *title = [NSString stringFromDate:[calendar dateFromComponents:nowComponents] WithFormat:@"yyyy/MM"];
    return title;
}

#pragma mark UIBarPositioningDelegate
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

#pragma mark - RMPZoomTransitionAnimating
- (UIImageView *)transitionSourceImageView {
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    CATScheduleViewControllerTableViewCell *cell = (CATScheduleViewControllerTableViewCell *)[self.tableView cellForRowAtIndexPath:selectedIndexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:cell.cellImageView.image];
    imageView.contentMode = cell.cellImageView.contentMode;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = NO;
    CGRect frameInSuperview = [cell.cellImageView convertRect:cell.cellImageView.frame toView:self.tableView.superview];
//    frameInSuperview.origin.x -= cell.layoutMargins.left;
//    frameInSuperview.origin.y -= cell.layoutMargins.top;
    imageView.frame = frameInSuperview;
    return imageView;
//    return self.selectingImageView;
}

- (UIColor *)transitionSourceBackgroundColor {
    return self.view.backgroundColor;
}

- (CGRect)transitionDestinationImageViewFrame {
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    CATScheduleViewControllerTableViewCell *cell = (CATScheduleViewControllerTableViewCell *)[self.tableView cellForRowAtIndexPath:selectedIndexPath];
    CGRect frameInSuperview = [cell.cellImageView convertRect:cell.cellImageView.frame toView:self.tableView.superview];
//    frameInSuperview.origin.x -= cell.layoutMargins.left;
//    frameInSuperview.origin.y -= cell.layoutMargins.top;
    return frameInSuperview;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    id <RMPZoomTransitionAnimating, RMPZoomTransitionDelegate> sourceTransition = (id<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>)source;
    id <RMPZoomTransitionAnimating, RMPZoomTransitionDelegate> destinationTransition = (id<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>)presented;
    if ([sourceTransition conformsToProtocol:@protocol(RMPZoomTransitionAnimating)] &&
        [destinationTransition conformsToProtocol:@protocol(RMPZoomTransitionAnimating)]) {
        RMPZoomTransitionAnimator *animator = [[RMPZoomTransitionAnimator alloc] init];
        animator.goingForward = YES;
        animator.sourceTransition = sourceTransition;
        animator.destinationTransition = destinationTransition;
        return animator;
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    id <RMPZoomTransitionAnimating, RMPZoomTransitionDelegate> sourceTransition = (id<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>)dismissed;
    id <RMPZoomTransitionAnimating, RMPZoomTransitionDelegate> destinationTransition = (id<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>)self;
    if ([sourceTransition conformsToProtocol:@protocol(RMPZoomTransitionAnimating)] &&
        [destinationTransition conformsToProtocol:@protocol(RMPZoomTransitionAnimating)]) {
        RMPZoomTransitionAnimator *animator = [[RMPZoomTransitionAnimator alloc] init];
        animator.goingForward = NO;
        animator.sourceTransition = sourceTransition;
        animator.destinationTransition = destinationTransition;
        return animator;
    }
    return nil;
}

#pragma mark - Segue
- (IBAction)returnActionForSegue:(UIStoryboardSegue *)segue {
    
}

@end
