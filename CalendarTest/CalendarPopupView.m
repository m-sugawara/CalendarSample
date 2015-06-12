//
//  CalendarPopupView.m
//  CalendarTest
//
//  Created by m_sugawara on 2015/06/12.
//  Copyright (c) 2015年 Zappallas. All rights reserved.
//

#import "CalendarPopupView.h"

@implementation CalendarPopupView

#pragma mark Designated Initializer

#pragma mark Conveniece Initializer
+ (CalendarPopupView *)popupViewWithDelegate:(id<CalendarPopupViewDelegate>)delegate {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([CalendarPopupView class]) bundle:nil];
    CalendarPopupView *popupView = [[nib instantiateWithOwner:nil options:nil] firstObject];
    popupView.delegate = delegate;
    
    return popupView;
}

#pragma mark LifeCycle
- (void)awakeFromNib {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark Actions
- (void)viewTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(calendarPopupViewDidTapView:)]) {
        [self.delegate calendarPopupViewDidTapView:self];
    }
}

@end
