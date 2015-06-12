//
//  CalendarPopupView.h
//  CalendarTest
//
//  Created by m_sugawara on 2015/06/12.
//  Copyright (c) 2015年 Zappallas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarPopupView;
@protocol CalendarPopupViewDelegate <NSObject>

- (void)calendarPopupViewDidTapView:(CalendarPopupView *)calendarPopupView;

@end

@interface CalendarPopupView : UIView

+ (CalendarPopupView *)popupViewWithDelegate:(id<CalendarPopupViewDelegate>)delegate;

@property(nonatomic)id<CalendarPopupViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
