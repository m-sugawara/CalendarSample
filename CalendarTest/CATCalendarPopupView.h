//
//  CalendarPopupView.h
//  CalendarTest
//
//  Created by m_sugawara on 2015/06/12.
//  Copyright (c) 2015年 Zappallas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CATCalendarPopupView;
@protocol CATCalendarPopupViewDelegate <NSObject>

- (void)calendarPopupViewDidTapView:(CATCalendarPopupView *)calendarPopupView;

@end

@interface CATCalendarPopupView : UIView

+ (CATCalendarPopupView *)popupViewWithDelegate:(id<CATCalendarPopupViewDelegate>)delegate;

@property(nonatomic)id<CATCalendarPopupViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
