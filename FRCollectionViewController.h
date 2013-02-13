//
//  FRCollectionViewController.h
//  FRCalendar
//
//  Created by Dr Thief on 13/02/13.
//  Copyright (c) 2013 Dr Thief. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRCollectionViewController : UICollectionViewController {
    NSCalendar *calendar;
    NSDate *monthShowing;
    NSMutableArray *dateArray;
    NSInteger section;
    NSInteger jump;
    NSInteger license;
}

@property(nonatomic, strong) NSCalendar *calendar;
@property(nonatomic, strong) NSDate *monthShowing;
@property(nonatomic, strong) NSMutableArray *dateArray;

@end