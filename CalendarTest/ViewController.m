//
//  ViewController.m
//  CalendarTest
//
//  Created by m_sugawara on 2015/06/11.
//  Copyright (c) 2015年 Zappallas. All rights reserved.
//

#import "ViewController.h"

#import "CalendarView.h"
#import "CalendarPopupView.h"

const CGFloat CellMargin = 2;
const NSInteger DaysPerWeek = 7;

@interface ViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIBarPositioningDelegate, CalendarPopupViewDelegate>

@property(nonatomic, weak)IBOutlet CalendarView *collectionView;
@property(nonatomic, weak)IBOutlet UINavigationBar *navigationBar;

@property(nonatomic)BOOL popupViewShowing;
@property(nonatomic, strong)CalendarPopupView *popupView;

@property(nonatomic, strong)NSDate *firstDateOfMonth;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // create popup view
    CalendarPopupView *popupView = [CalendarPopupView popupViewWithDelegate:self];
    CGFloat margin = 40.0f;
    popupView.frame = CGRectMake(margin,margin * 2.0f,
                                 self.view.bounds.size.width - 2.0f * margin,
                                 self.view.bounds.size.height/3.0f);
    popupView.alpha = 0.0f;
    [self.view addSubview:popupView];
    self.popupView = popupView;
    
    // setup date
    NSDate *now = [NSDate date];
    self.firstDateOfMonth = [self firstDateOfMonthFromDate:now difference:0];

    [self reloadCalendarTitle];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // おそらく、Autolayoutの計算をしてから、Tabbarを読み込んでおり、
    // Tabbarの高さの分だけ計算がずれている。
    // 上記の回避策として、ここでreloadDataをして、無理やりAutolayoutを再読み込みしている。
    // TODO:もっと良い方法を探したほうがよさそう。
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private Methods
- (BOOL)isSelectedMonthsDate:(NSDate *)date {
    if ([[self stringFromDate:date format:@"MM"] compare:[self stringFromDate:self.firstDateOfMonth format:@"MM"]] == NSOrderedSame) {
        return YES;
    }
    
    return NO;
}
- (void)reloadCalendarTitle {
    self.navigationBar.topItem.title = [self stringFromDate:self.firstDateOfMonth format:@"YYYY年 MM月"];
}

- (NSDate *)firstDateOfMonthFromDate:(NSDate *)date difference:(NSInteger)different {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:date];
    
    if (different && different != 0) {
        components.month += different;
    }
    components.day = 1;
    
    return [calendar dateFromComponents:components];
}

- (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format {
    NSAssert(format, @"format must not be nil");
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}


- (NSDate *)dateForCellAtIndexPath:(NSIndexPath *)indexPath {
    // 月の初日が週の何日目か　を計算する
    NSInteger ordinaryOfFirstDay = [[NSCalendar currentCalendar]
                                    ordinalityOfUnit:NSCalendarUnitDay
                                    inUnit:NSCalendarUnitWeekOfMonth
                                    forDate:self.firstDateOfMonth];
    // 月の初日とindexPath.item番目のセルに表示する日　の差を計算する
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = indexPath.item - (ordinaryOfFirstDay - 1);
    
    NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                                 toDate:self.firstDateOfMonth
                                                                options:0];
    
    return date;
}

#pragma mark Accessor
- (void)setPopupViewShowing:(BOOL)popupViewShowing {
    _popupViewShowing = popupViewShowing;
    
    // ポップアップを表示
    if (_popupViewShowing) {
        [self.collectionView setUserInteractionEnabled:NO];
        [UIView animateWithDuration:0.2f animations:^{
            self.popupView.alpha = 1.0f;
        }];
    }
    // ポップアップを非表示
    else {
        [UIView animateWithDuration:0.2f animations:^{
            self.popupView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.collectionView setUserInteractionEnabled:YES];
            }
        }];
    }
}

#pragma mark Actions
- (IBAction)prevItemTapped:(id)sender {
    // ポップアップ表示中はボタン操作無効
    if (self.popupViewShowing) {
        return;
    }
    
    self.firstDateOfMonth = [self firstDateOfMonthFromDate:self.firstDateOfMonth difference:-1];
    [self.collectionView reloadData];
    [self reloadCalendarTitle];
}

- (IBAction)nextItemTapped:(id)sender {
    // ポップアップ表示中はボタン操作無効
    if (self.popupViewShowing) {
        return;
    }
    
    self.firstDateOfMonth = [self firstDateOfMonthFromDate:self.firstDateOfMonth difference:1];
    [self.collectionView reloadData];
    [self reloadCalendarTitle];
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = [self dateForCellAtIndexPath:indexPath];
    NSLog(@"%@", [self stringFromDate:date format:@"dd"]);
    
    // 今月以外の場所をタップしていたらキャンセル
    if (![self isSelectedMonthsDate:date]) {
        return;
    }
    
    // ポップアップの表示内容を設定
    self.popupView.titleLabel.text = [self stringFromDate:date format:@"yyyy/MM/dd"];
    self.popupView.descriptionLabel.text = @"description";
    
    // カレンダータップを不可にしてポップアップ表示
    self.popupViewShowing = YES;
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // calculate number of weeks
    NSRange rangeOfWeeks = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfMonth
                                                              inUnit:NSCalendarUnitMonth
                                                             forDate:self.firstDateOfMonth];
    NSUInteger numberOfWeeks = rangeOfWeeks.length;
    NSInteger numberOfItems = numberOfWeeks * DaysPerWeek;
    
    return numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    // 日付を取得
    NSDate *date = [self dateForCellAtIndexPath:indexPath];
    // ラベルに日付を設定
    cell.dayLabel.text = [self stringFromDate:date format:@"d"];
    
    // セルに設定する日が、選択した月と同じかどうかでフォント変更
    if ([self isSelectedMonthsDate:date]) {
        cell.dayLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    }
    else {
        cell.dayLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    
    return cell;
}

# pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger numberOfMargin = 8;
    CGFloat width = floorf((collectionView.frame.size.width - CellMargin * numberOfMargin) / DaysPerWeek);
    
    CGFloat height = width * 1.0f;
    
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(CellMargin, CellMargin, CellMargin, CellMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return CellMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CellMargin;
}

#pragma mark UIBarPositioningDelegate
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

#pragma mark CalendarPopupViewDelegate
- (void)calendarPopupViewDidTapView:(CalendarPopupView *)calendarPopupView {
    self.popupViewShowing = NO;
}

@end
