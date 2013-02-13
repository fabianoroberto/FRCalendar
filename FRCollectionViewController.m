//
//  FRCollectionViewController.m
//  FRCalendar
//
//  Created by Dr Thief on 13/02/13.
//  Copyright (c) 2013 Dr Thief. All rights reserved.
//

#import "FRCollectionViewController.h"
#import "FRCalendarCell.h"
#import "FRHeaderView.h"
#import "FRFooterView.h"
#import <QuartzCore/QuartzCore.h>

@implementation FRCollectionViewController

@synthesize calendar = _calendar;
@synthesize monthShowing = _monthShowing;
@synthesize dateArray = _dateArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [self.calendar setLocale:[NSLocale currentLocale]];
    self.monthShowing = [NSDate date];
    
    [self fillDateArray];
}

-(void) reloadData {
    [self fillDateArray];
    [self.collectionView reloadData];
}

-(void) fillDateArray {
    NSDate *date = [self firstDayOfMonthContainingDate:self.monthShowing];
    while ([self placeInWeekForDate:date] != 0) {
        date = [self previousDay:date];
    }
    
    NSMutableArray *dates= [NSMutableArray array];
    for (NSInteger i = 1; i <= 42; i++) {
        [dates addObject:date];
        date = [self nextDay:date];
    }
    
    self.dateArray = dates;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FRCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"day" forIndexPath:indexPath];
    
    NSDate *date = [self.dateArray objectAtIndex:indexPath.item];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    cell.day.text = stringFromDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *firstDayOfMonth = [self firstDayOfMonthContainingDate:self.monthShowing];
    NSDate *firstDayOfNextMonth = [self firstDayOfNextMonthContainingDate:self.monthShowing];
    
    NSInteger numberOfDaysSinceBeginningOfThisMonth = [self numberOfDaysFromDate:firstDayOfMonth toDate:date];
    NSInteger numberOfDaysAfterBeginningOfNextMonth = [self numberOfDaysFromDate:firstDayOfNextMonth toDate:date];
    
    //customize cell
    if (indexPath.item % 5 != 0) {
        cell.labelA.text = @"";
        cell.labelB.text = @"";
        cell.imageCell.image = nil;
    } else {
        cell.labelA.text = @"A";
        cell.labelB.text = @"B";
        cell.imageCell.image = [UIImage imageNamed:@"R.png"];
    }
    
    if (numberOfDaysSinceBeginningOfThisMonth < 0) {
        cell.day.textColor = [UIColor lightGrayColor];
        cell.backgroundColor = [UIColor grayColor];
    } else if(numberOfDaysAfterBeginningOfNextMonth >= 0) {
        cell.day.textColor = [UIColor lightGrayColor];
        cell.backgroundColor = [UIColor grayColor];
    } else if ([self dateIsToday:date]) {
        cell.backgroundColor = [UIColor cyanColor];
        cell.day.textColor = [UIColor grayColor];
    } else {
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.day.textColor = [UIColor whiteColor];
    }
    
    [cell.layer setBorderWidth:1.0f];
    [cell.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dateArray count];
}

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if(kind == UICollectionElementKindSectionHeader) {
        FRHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
        [monthFormatter setTimeStyle:NSDateFormatterNoStyle];
        monthFormatter.dateFormat = @"LLLL";
        
        NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
        [yearFormatter setTimeStyle:NSDateFormatterNoStyle];
        yearFormatter.dateFormat = @"yyyy";
        
        headerView.currentMonth.text = [monthFormatter stringFromDate:_monthShowing];
        headerView.currentYear.text = [yearFormatter stringFromDate:_monthShowing];
        
        return headerView;
    } else {
        FRFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        
        [footerView.layer setBorderWidth:1.0f];
        [footerView.layer setBorderColor:[UIColor whiteColor].CGColor];
        
        return footerView;
    }
}

- (IBAction)CellClicked:(id)sender {
    UICollectionViewCell *clickedCell = (UICollectionViewCell *)[[sender superview] superview];
    NSIndexPath *clickedButtonPath = [self.collectionView indexPathForCell:clickedCell];
    
    NSDate *date = [self.dateArray objectAtIndex:clickedButtonPath.item];
    NSDate *firstDayOfMonth = [self firstDayOfMonthContainingDate:self.monthShowing];
    NSDate *firstDayOfNextMonth = [self firstDayOfNextMonthContainingDate:self.monthShowing];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd LLLL yyyy"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    NSInteger numberOfDaysSinceBeginningOfThisMonth = [self numberOfDaysFromDate:firstDayOfMonth toDate:date];
    NSInteger numberOfDaysAfterBeginningOfNextMonth = [self numberOfDaysFromDate:firstDayOfNextMonth toDate:date];
    
    if (numberOfDaysSinceBeginningOfThisMonth < 0) {
        [self moveCalendarToPreviousMonth:sender];
    } else if(numberOfDaysAfterBeginningOfNextMonth >= 0) {
        [self moveCalendarToNextMonth:sender];
    } else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Pressed" message:stringFromDate delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}

- (IBAction)moveCalendarToPreviousMonth:(id)sender {
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    [comps setMonth:-1];
    self.monthShowing = [self.calendar dateByAddingComponents:comps toDate:self.monthShowing options:0];
    [self reloadData];
}

- (IBAction)moveCalendarToNextMonth:(id)sender {
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    self.monthShowing = [self.calendar dateByAddingComponents:comps toDate:self.monthShowing options:0];
    [self reloadData];
}

- (IBAction)goToToday:(id)sender {
    self.monthShowing = [NSDate date];
    [self reloadData];
}

- (NSInteger)calculateDayNumber:(NSDate *)date {
    NSInteger placeInWeek = [self placeInWeekForDate:date];
    
    return placeInWeek;
}

#pragma mark - Calendar helpers

- (NSDate *)firstDayOfMonthContainingDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    comps.day = 1;
    return [self.calendar dateFromComponents:comps];
}

- (NSDate *)firstDayOfNextMonthContainingDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    comps.day = 1;
    comps.month = comps.month + 1;
    return [self.calendar dateFromComponents:comps];
}

- (NSInteger)placeInWeekForDate:(NSDate *)date {
    NSDateComponents *compsFirstDayInMonth = [self.calendar components:NSWeekdayCalendarUnit fromDate:date];
    return (compsFirstDayInMonth.weekday - 1 - self.calendar.firstWeekday + 8) % 7;
}

- (BOOL)dateIsToday:(NSDate *)date {
    return [self date:[NSDate date] isSameDayAsDate:date];
}

- (BOOL)date:(NSDate *)date1 isSameDayAsDate:(NSDate *)date2 {
    // Both dates must be defined, or they're not the same
    if (date1 == nil || date2 == nil) {
        return NO;
    }
    
    NSDateComponents *day = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date1];
    NSDateComponents *day2 = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date2];
    return ([day2 day] == [day day] &&
            [day2 month] == [day month] &&
            [day2 year] == [day year] &&
            [day2 era] == [day era]);
}

- (NSInteger)weekNumberInMonthForDate:(NSDate *)date {
    // Return zero-based week in month
    NSInteger placeInWeek = [self placeInWeekForDate:self.monthShowing];
    NSDateComponents *comps = [self.calendar components:(NSDayCalendarUnit) fromDate:date];
    return (comps.day + placeInWeek - 1) / 7;
}

- (NSInteger)numberOfWeeksInMonthContainingDate:(NSDate *)date {
    return [self.calendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

- (NSDate *)nextDay:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    return [self.calendar dateByAddingComponents:comps toDate:date options:0];
}

- (NSDate *)previousDay:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-1];
    return [self.calendar dateByAddingComponents:comps toDate:date options:0];
}

- (NSInteger)numberOfDaysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSInteger startDay = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:startDate];
    NSInteger endDay = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:endDate];
    return endDay - startDay;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
